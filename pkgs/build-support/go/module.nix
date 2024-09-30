{ go, cacert, git, lib, stdenv }:

{ name ? "${args'.pname}-${args'.version}"
, src
, nativeBuildInputs ? [ ]
, passthru ? { }
, patches ? [ ]

  # A function to override the goModules derivation
, overrideModAttrs ? (finalAttrs: previousAttrs: { })

  # path to go.mod and go.sum directory
, modRoot ? "./"

  # vendorHash is the SRI hash of the vendored dependencies
  #
  # if vendorHash is null, then we won't fetch any dependencies and
  # rely on the vendor folder within the source.
, vendorHash ? throw (
    if args'?vendorSha256 then
      "buildGoModule: Expect vendorHash instead of vendorSha256"
    else
      "buildGoModule: vendorHash is missing"
  )
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

, ldflags ? [ ]

, GOFLAGS ? [ ]

  # needed for buildFlags{,Array} warning
, buildFlags ? ""
, buildFlagsArray ? ""

, ...
}@args':

assert goPackagePath != "" -> throw "`goPackagePath` is not needed with `buildGoModule`";

let
  args = removeAttrs args' [ "overrideModAttrs" "vendorSha256" ];

  GO111MODULE = "on";
  GOTOOLCHAIN = "local";

in
(stdenv.mkDerivation (finalAttrs:
  args
  // {

  inherit modRoot vendorHash deleteVendor proxyVendor;
  goModules = if (finalAttrs.vendorHash == null) then "" else
  (stdenv.mkDerivation {
    name = "${finalAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}"}-go-modules";

    nativeBuildInputs = (finalAttrs.nativeBuildInputs or [ ]) ++ [ go git cacert ];

    inherit (finalAttrs) src modRoot;
    inherit (go) GOOS GOARCH;
    inherit GO111MODULE GOTOOLCHAIN;

    # The following inheritence behavior is not trivial to expect, and some may
    # argue it's not ideal. Changing it may break vendor hashes in Nixpkgs and
    # out in the wild. In anycase, it's documented in:
    # doc/languages-frameworks/go.section.md
    prePatch = finalAttrs.prePatch or "";
    patches = finalAttrs.patches or [ ];
    patchFlags = finalAttrs.patchFlags or [ ];
    postPatch = finalAttrs.postPatch or "";
    preBuild = finalAttrs.preBuild or "";
    postBuild = finalAttrs.modPostBuild or "";
    sourceRoot = finalAttrs.sourceRoot or "";
    setSourceRoot = finalAttrs.setSourceRoot or "";
    env = finalAttrs.env or { };

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
      "GOPROXY"
    ];

    configurePhase = args.modConfigurePhase or ''
      runHook preConfigure
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      cd "$modRoot"
      runHook postConfigure
    '';

    buildPhase = args.modBuildPhase or (''
      runHook preBuild
    '' + lib.optionalString finalAttrs.deleteVendor ''
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

      export GIT_SSL_CAINFO=$NIX_SSL_CERT_FILE
      ${if finalAttrs.proxyVendor then ''
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

      ${if finalAttrs.proxyVendor then ''
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
    outputHash = finalAttrs.vendorHash;
    # Handle empty vendorHash; avoid
    # error: empty hash requires explicit hash algorithm
    outputHashAlgo = if finalAttrs.vendorHash == "" then "sha256" else null;
    # in case an overlay clears passthru by accident, don't fail evaluation
  }).overrideAttrs (finalAttrs.passthru.overrideModAttrs or overrideModAttrs);

    nativeBuildInputs = [ go ] ++ nativeBuildInputs;

    inherit (go) GOOS GOARCH;

    GOFLAGS = GOFLAGS
      ++ lib.warnIf (lib.any (lib.hasPrefix "-mod=") GOFLAGS) "use `proxyVendor` to control Go module/vendor behavior instead of setting `-mod=` in GOFLAGS"
        (lib.optional (!finalAttrs.proxyVendor) "-mod=vendor")
      ++ lib.warnIf (builtins.elem "-trimpath" GOFLAGS) "`-trimpath` is added by default to GOFLAGS by buildGoModule when allowGoReference isn't set to true"
        (lib.optional (!allowGoReference) "-trimpath");
    inherit CGO_ENABLED enableParallelBuilding GO111MODULE GOTOOLCHAIN;

    # If not set to an explicit value, set the buildid empty for reproducibility.
    ldflags = ldflags ++ lib.optional (!lib.any (lib.hasPrefix "-buildid=") ldflags) "-buildid=";

    configurePhase = args.configurePhase or (''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      export GOPROXY=off
      export GOSUMDB=off
      cd "$modRoot"
    '' + lib.optionalString (finalAttrs.vendorHash != null) ''
      ${if finalAttrs.proxyVendor then ''
        export GOPROXY="file://$goModules"
      '' else ''
        rm -rf vendor
        cp -r --reflink=auto "$goModules" vendor
      ''}
    '' + ''

      # currently pie is only enabled by default in pkgsMusl
      # this will respect the `hardening{Disable,Enable}` flags if set
      if [[ $NIX_HARDENING_ENABLE =~ "pie" ]]; then
        export GOFLAGS="-buildmode=pie $GOFLAGS"
      fi

      runHook postConfigure
    '');

    buildPhase = args.buildPhase or (
      lib.warnIf (buildFlags != "" || buildFlagsArray != "")
        "`buildFlags`/`buildFlagsArray` are deprecated and will be removed in the 24.11 release. Use the `ldflags` and/or `tags` attributes instead of `buildFlags`/`buildFlagsArray`"
      lib.warnIf (builtins.elem "-buildid=" ldflags)
        "`-buildid=` is set by default as ldflag by buildGoModule"
    ''
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

        declare -ga buildFlagsArray
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

    passthru = {
      inherit go;
      # Canonicallize `overrideModAttrs` as an attribute overlay.
      # `passthru.overrideModAttrs` will be overridden
      # when users want to override `goModules`.
      overrideModAttrs = lib.toExtension overrideModAttrs;
    } // passthru;

    meta = {
      # Add default meta information
      platforms = go.meta.platforms or lib.platforms.all;
    } // meta;
  }
))
