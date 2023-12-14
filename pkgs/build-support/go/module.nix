{ go, cacert, git, lib, stdenv }:

{ name ? "${args'.pname}-${args'.version}"
, src
, nativeBuildInputs ? [ ]
, passthru ? { }
, patches ? [ ]

  # A function to override the goModules derivation
, overrideModAttrs ? (_oldAttrs: { })

  # path to go.mod and go.sum directory
, modRoot ? "./"

  # vendorHash is the SRI hash of the vendored dependencies
  #
  # if vendorHash is null, then we won't fetch any dependencies and
  # rely on the vendor folder within the source.
, vendorHash ? args'.vendorSha256 or (throw "buildGoModule: vendorHash is missing")
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

, meta ? { }

  # Not needed with buildGoModule
, goPackagePath ? ""

  # needed for buildFlags{,Array} warning
, buildFlags ? ""
, buildFlagsArray ? ""

, ...
}@args':

assert goPackagePath != "" -> throw "`goPackagePath` is not needed with `buildGoModule`";
assert (args' ? vendorHash && args' ? vendorSha256) -> throw "both `vendorHash` and `vendorSha256` set. only one can be set.";

let
  args = removeAttrs args' [ "overrideModAttrs" "vendorSha256" "vendorHash" ];

  GO111MODULE = "on";
  GOTOOLCHAIN = "local";

  goModules = if (vendorHash == null) then "" else
  (stdenv.mkDerivation {
    name = "${name}-go-modules";

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ go git cacert ];

    inherit (args) src;
    inherit (go) GOOS GOARCH;
    inherit GO111MODULE GOTOOLCHAIN;

    # The following inheritence behavior is not trivial to expect, and some may
    # argue it's not ideal. Changing it may break vendor hashes in Nixpkgs and
    # out in the wild. In anycase, it's documented in:
    # doc/languages-frameworks/go.section.md
    prePatch = args.prePatch or "";
    patches = args.patches or [ ];
    patchFlags = args.patchFlags or [ ];
    postPatch = args.postPatch or "";
    preBuild = args.preBuild or "";
    postBuild = args.modPostBuild or "";
    sourceRoot = args.sourceRoot or "";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
      "GOPROXY"
    ];

    configurePhase = args.modConfigurePhase or ''
      runHook preConfigure
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      cd "${modRoot}"
      runHook postConfigure
    '';

    buildPhase = args.modBuildPhase or (''
      runHook preBuild
    '' + lib.optionalString deleteVendor ''
      if [ ! -d vendor ]; then
        echo "vendor folder does not exist, 'deleteVendor' is not needed"
        exit 10
      else
        rm -rf vendor
      fi
    '' + ''
      if [ -d vendor ]; then
        echo "vendor folder exists, please set 'vendorHash = null;' in your expression"
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
    '');

    installPhase = args.modInstallPhase or ''
      runHook preInstall

      ${if proxyVendor then ''
        rm -rf "''${GOPATH}/pkg/mod/cache/download/sumdb"
        cp -r --reflink=auto "''${GOPATH}/pkg/mod/cache/download" $out
      '' else ''
        cp -r --reflink=auto vendor $out
      ''}

      if ! [ "$(ls -A $out)" ]; then
        echo "vendor folder is empty, please set 'vendorHash = null;' in your expression"
        exit 10
      fi

      runHook postInstall
    '';

    dontFixup = true;

    outputHashMode = "recursive";
    outputHash = vendorHash;
    outputHashAlgo = if args' ? vendorSha256 || vendorHash == "" then "sha256" else null;
  }).overrideAttrs overrideModAttrs;

  package = stdenv.mkDerivation (args // {
    nativeBuildInputs = [ go ] ++ nativeBuildInputs;

    inherit (go) GOOS GOARCH;

    GOFLAGS = lib.optionals (!proxyVendor) [ "-mod=vendor" ] ++ lib.optionals (!allowGoReference) [ "-trimpath" ];
    inherit CGO_ENABLED enableParallelBuilding GO111MODULE GOTOOLCHAIN;

    configurePhase = args.configurePhase or (''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      export GOPROXY=off
      export GOSUMDB=off
      cd "$modRoot"
    '' + lib.optionalString (vendorHash != null) ''
      ${if proxyVendor then ''
        export GOPROXY=file://${goModules}
      '' else ''
        rm -rf vendor
        cp -r --reflink=auto ${goModules} vendor
      ''}
    '' + ''

      # currently pie is only enabled by default in pkgsMusl
      # this will respect the `hardening{Disable,Enable}` flags if set
      if [[ $NIX_HARDENING_ENABLE =~ "pie" ]]; then
        export GOFLAGS="-buildmode=pie $GOFLAGS"
      fi

      runHook postConfigure
    '');

    buildPhase = args.buildPhase or (''
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
        flags+=(''${tags:+-tags=''${tags// /,}})
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
    '');

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

    passthru = passthru // { inherit go goModules vendorHash; } // { inherit (args') vendorSha256; };

    meta = {
      # Add default meta information
      platforms = go.meta.platforms or lib.platforms.all;
    } // meta;
  });
in
lib.warnIf (args' ? vendorSha256) "`vendorSha256` is deprecated. Use `vendorHash` instead"
lib.warnIf (buildFlags != "" || buildFlagsArray != "")
  "Use the `ldflags` and/or `tags` attributes instead of `buildFlags`/`buildFlagsArray`"
  package
