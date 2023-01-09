{ go, cacert, git, lib, stdenv }:

{ name ? "${args'.pname}-${args'.version}"
, src
, buildInputs ? []
, nativeBuildInputs ? []
, passthru ? {}
, patches ? []

# Go linker flags, passed to go via -ldflags
, ldflags ? []

# Go tags, passed to go via -tag
, tags ? []

# A function to override the go-modules derivation
, overrideModAttrs ? (_oldAttrs : {})

# path to go.mod and go.sum directory
, modRoot ? "./"

# vendorHash is the SRI hash of the vendored dependencies
#
# if vendorHash is null, then we won't fetch any dependencies and
# rely on the vendor folder within the source.
, vendorHash ? "_unset"
# same as vendorHash, but outputHashAlgo is hardcoded to sha256
# so regular base32 sha256 hashes work
, vendorSha256 ? "_unset"
# Whether to delete the vendor folder supplied with the source.
, deleteVendor ? false
# Whether to fetch (go mod download) and proxy the vendor directory.
# This is useful if your code depends on c code and go mod tidy does not
# include the needed sources to build or if any dependency has case-insensitive
# conflicts which will produce platform dependant `vendorHash` checksums.
, proxyVendor ? false

# We want parallel builds by default
, enableParallelBuilding ? true

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, CGO_ENABLED ? go.CGO_ENABLED

, meta ? {}

# Not needed with buildGoModule
, goPackagePath ? ""

# needed for buildFlags{,Array} warning
, buildFlags ? ""
, buildFlagsArray ? ""

, ... }@args':

with builtins;

assert goPackagePath != "" -> throw "`goPackagePath` is not needed with `buildGoModule`";
assert (vendorSha256 == "_unset" && vendorHash == "_unset") -> throw "either `vendorHash` or `vendorSha256` is required";
assert (vendorSha256 != "_unset" && vendorHash != "_unset") -> throw "both `vendorHash` and `vendorSha256` set. only one can be set.";

let
  hasAnyVendorHash = (vendorSha256 != null && vendorSha256 != "_unset") || (vendorHash != null && vendorHash != "_unset");
  vendorHashType =
    if hasAnyVendorHash then
      if vendorSha256 != null && vendorSha256 != "_unset" then
        "sha256"
      else
        "sri"
    else
      null;

  args = removeAttrs args' [ "overrideModAttrs" "vendorSha256" "vendorHash" ];

  go-modules = if hasAnyVendorHash then stdenv.mkDerivation (let modArgs = {

    name = "${name}-go-modules";

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ go git cacert ];

    inherit (args) src;
    inherit (go) GOOS GOARCH;

    patches = args.patches or [];
    patchFlags = args.patchFlags or [];
    preBuild = args.preBuild or "";
    sourceRoot = args.sourceRoot or "";

    GO111MODULE = "on";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND" "SOCKS_SERVER" "GOPROXY"
    ];

    configurePhase = args.modConfigurePhase or ''
      runHook preConfigure
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      # https://sourcehut.org/blog/2023-01-09-gomodulemirror/
      export GOPRIVATE=git.sr.ht
      cd "${modRoot}"
      runHook postConfigure
    '';

    buildPhase = args.modBuildPhase or ''
      runHook preBuild
    '' + lib.optionalString (deleteVendor == true) ''
      if [ ! -d vendor ]; then
        echo "vendor folder does not exist, 'deleteVendor' is not needed"
        exit 10
      else
        rm -rf vendor
      fi
    '' + ''
      if [ -d vendor ]; then
        echo "vendor folder exists, please set 'vendorHash = null;' or 'vendorSha256 = null;' in your expression"
        exit 10
      fi

    ${if proxyVendor then ''
      mkdir -p "''${GOPATH}/pkg/mod/cache/download"
      go mod download
    '' else ''
      if (( "''${NIX_DEBUG:-0}" >= 1 )); then
        goModVendorFlags+=(-v)
      fi
      go mod vendor "''${goModVendorFlags[@]}"
    ''}

      mkdir -p vendor

      runHook postBuild
    '';

    installPhase = args.modInstallPhase or ''
      runHook preInstall

    ${if proxyVendor then ''
      rm -rf "''${GOPATH}/pkg/mod/cache/download/sumdb"
      cp -r --reflink=auto "''${GOPATH}/pkg/mod/cache/download" $out
    '' else ''
      cp -r --reflink=auto vendor $out
    ''}

      runHook postInstall
    '';

    dontFixup = true;
  }; in modArgs // (
      {
        outputHashMode = "recursive";
      } // (if (vendorHashType == "sha256") then {
        outputHashAlgo = "sha256";
        outputHash = vendorSha256;
      } else {
        outputHash = vendorHash;
      }) // (lib.optionalAttrs (vendorHashType == "sri" && vendorHash == "") {
        outputHashAlgo = "sha256";
      })
  ) // overrideModAttrs modArgs) else "";

  package = stdenv.mkDerivation (args // {
    nativeBuildInputs = [ go ] ++ nativeBuildInputs;

    inherit (go) GOOS GOARCH;

    GO111MODULE = "on";
    GOFLAGS = lib.optionals (!proxyVendor) [ "-mod=vendor" ] ++ lib.optionals (!allowGoReference) [ "-trimpath" ];
    inherit CGO_ENABLED;

    configurePhase = args.configurePhase or ''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      export GOPROXY=off
      export GOSUMDB=off
      cd "$modRoot"
    '' + lib.optionalString hasAnyVendorHash ''
      ${if proxyVendor then ''
        export GOPROXY=file://${go-modules}
      '' else ''
        rm -rf vendor
        cp -r --reflink=auto ${go-modules} vendor
      ''}
    '' + ''

      runHook postConfigure
    '';

    buildPhase = args.buildPhase or ''
      runHook preBuild

      exclude='\(/_\|examples\|Godeps\|testdata'
      if [[ -n "$excludedPackages" ]]; then
        IFS=' ' read -r -a excludedArr <<<$excludedPackages
        printf -v excludedAlternates '%s\\|' "''${excludedArr[@]}"
        excludedAlternates=''${excludedAlternates%\\|} # drop final \| added by printf
        exclude+='\|'"$excludedAlternates"
      fi
      exclude+='\)'

      buildGoDir() {
        local cmd="$1" dir="$2"

        . $TMPDIR/buildFlagsArray

        declare -a flags
        flags+=($buildFlags "''${buildFlagsArray[@]}")
        flags+=(''${tags:+-tags=${lib.concatStringsSep "," tags}})
        flags+=(''${ldflags:+-ldflags="$ldflags"})
        flags+=("-p" "$NIX_BUILD_CORES")

        if [ "$cmd" = "test" ]; then
          flags+=(-vet=off)
          flags+=($checkFlags)
        fi

        local OUT
        if ! OUT="$(go $cmd "''${flags[@]}" $dir 2>&1)"; then
          if ! echo "$OUT" | grep -qE '(no( buildable| non-test)?|build constraints exclude all) Go (source )?files'; then
            echo "$OUT" >&2
            return 1
          fi
        fi
        if [ -n "$OUT" ]; then
          echo "$OUT" >&2
        fi
        return 0
      }

      getGoDirs() {
        local type;
        type="$1"
        if [ -n "$subPackages" ]; then
          echo "$subPackages" | sed "s,\(^\| \),\1./,g"
        else
          find . -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort --unique | grep -v "$exclude"
        fi
      }

      if (( "''${NIX_DEBUG:-0}" >= 1 )); then
        buildFlagsArray+=(-x)
      fi

      if [ ''${#buildFlagsArray[@]} -ne 0 ]; then
        declare -p buildFlagsArray > $TMPDIR/buildFlagsArray
      else
        touch $TMPDIR/buildFlagsArray
      fi
      if [ -z "$enableParallelBuilding" ]; then
          export NIX_BUILD_CORES=1
      fi
      for pkg in $(getGoDirs ""); do
        echo "Building subPackage $pkg"
        buildGoDir install "$pkg"
      done
    '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      # normalize cross-compiled builds w.r.t. native builds
      (
        dir=$GOPATH/bin/${go.GOOS}_${go.GOARCH}
        if [[ -n "$(shopt -s nullglob; echo $dir/*)" ]]; then
          mv $dir/* $dir/..
        fi
        if [[ -d $dir ]]; then
          rmdir $dir
        fi
      )
    '' + ''
      runHook postBuild
    '';

    doCheck = args.doCheck or true;
    checkPhase = args.checkPhase or ''
      runHook preCheck
      # We do not set trimpath for tests, in case they reference test assets
      export GOFLAGS=''${GOFLAGS//-trimpath/}

      for pkg in $(getGoDirs test); do
        buildGoDir test "$pkg"
      done

      runHook postCheck
    '';

    installPhase = args.installPhase or ''
      runHook preInstall

      mkdir -p $out
      dir="$GOPATH/bin"
      [ -e "$dir" ] && cp -r $dir $out

      runHook postInstall
    '';

    strictDeps = true;

    disallowedReferences = lib.optional (!allowGoReference) go;

    passthru = passthru // { inherit go go-modules vendorSha256 vendorHash; };

    enableParallelBuilding = enableParallelBuilding;

    meta = {
      # Add default meta information
      platforms = go.meta.platforms or lib.platforms.all;
    } // meta;
  });
in
lib.warnIf (buildFlags != "" || buildFlagsArray != "")
  "Use the `ldflags` and/or `tags` attributes instead of `buildFlags`/`buildFlagsArray`"
  package
