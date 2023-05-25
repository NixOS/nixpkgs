{ lib
, stdenv
, cacert
, git
, go
}:

rattrs:

(stdenv.mkDerivation (finalAttrs: (
{ src
, nativeBuildInputs ? [ ]
, passthru ? { }

  # A function to override the go-modules derivation
, overrideModAttrs ? (_finalAttrs: _previousAttrs: { })

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

, meta ? { }

  # Not needed with buildGoModule
, goPackagePath ? ""

  # needed for buildFlags{,Array} warning
, buildFlags ? null
, buildFlagsArray ? null

, ...
}@args:
  let
    hasAnyVendorHash = finalAttrs.vendorHash != null && finalAttrs.vendorHash != "_unset" || finalAttrs.vendorSha256 != null && finalAttrs.vendorSha256 != "_unset";
  in
  (removeAttrs args [
    # These arguments won't be passed down to later overlays

    "overrideModAttrs"

    # Syntax sugar to manually specify the corresponding phases
    # of the `go-modules` sub-derivation.
    "modConfigurePhase"
    "modBuildPhase"
    "modeInstallPhase"
  ]) // {
    inherit
      modRoot
      vendorHash
      vendorSha256
      deleteVendor
      proxyVendor
      ;

    # These phases will be shared with the 'go-modules` sub-derivation
    # so we give them default values if not specified.
    preUnpack = args.preUnpack or null;
    unpackPhase = args.unapckPhase or null;
    postUnpack = args.postUnpack or null;
    sourceRoot = args.sourceRoot or null;
    prePatch = args.prePatch or null;
    patches = args.patches or [ ];
    patchFlags = args.patchFlags or [ ];
    patchPhase = args.patchPhase or null;
    postPatch = args.postPatch or null;
    preBuild = args.preBuild or null;
    postBuild = args.postBuild or null;

    # `configurePhase`, `buildPhase` and `checkPhase` attributes can be set,
    # but their default values are the implementation of this builder,
    # so leave them unset unless you need to overwrite them.
    #
    # If you would like to use `stdenv.mkDerivation`-provided phases,
    # set the corresponding phases to `null`.

    # Fixed output derivation containing Go modules
    go-modules = if (!hasAnyVendorHash) then "" else
    (stdenv.mkDerivation (finalModAttrs: {

      nativeBuildInputs = finalAttrs.nativeBuildInputs or [ ] ++ [ cacert git go ];

      inherit (finalAttrs) src;

      # The following inheritence behavior is not trivial to expect, and some may
      # argue it's not ideal. Changing it may break vendor hashes in Nixpkgs and
      # out in the wild. In anycase, it's documented in:
      # doc/languages-frameworks/go.section.md
      inherit (finalAttrs)
        prePatch
        patches
        patchFlags
        postPatch
        preBuild
        sourceRoot
        ;

      postBuild = args.modPostBuild or null;

      inherit (go) GOOS GOARCH;
      GO111MODULE = "on";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
        "GOPROXY"
      ];

      configurePhase = args.modConfigurePhase or ''
        runHook preConfigure
        export GOCACHE=$TMPDIR/go-cache
        export GOPATH="$TMPDIR/go"
        cd "${finalAttrs.modRoot}"
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
          echo "vendor folder exists, please set 'vendorHash = null;' or 'vendorSha256 = null;' in your expression"
          exit 10
        fi

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
          echo "vendor folder is empty, please set 'vendorHash = null;' or 'vendorSha256 = null;' in your expression"
          exit 10
        fi

        runHook postInstall
      '';

      dontFixup = true;

      outputHashMode = "recursive";
      outputHashAlgo = if finalAttrs.vendorSha256 != "_unset" then "sha256" else null;
      outputHash = if finalAttrs.vendorHash != "_unset" then finalAttrs.vendorHash else finalAttrs.vendorSha256;
    }
    // (if (args ? pname && args.pname != "" && args ? version) then {
      pname = "go-modules-${finalAttrs.pname}";
      inherit (finalAttrs) version;
    } else {
      name = "go-modules-${finalAttrs.name}";
    }))).overrideAttrs overrideModAttrs;

    nativeBuildInputs = [ go ] ++ args.nativeBuildInputs or [ ];

    inherit (go) GOOS GOARCH;

    GO111MODULE = "on";
    inherit CGO_ENABLED enableParallelBuilding;
    GOFLAGS = lib.optionals (!finalAttrs.proxyVendor) [ "-mod=vendor" ] ++ lib.optionals (!finalAttrs.allowGoReference) [ "-trimpath" ];

    configurePhase = args.configurePhase or (''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      export GOPROXY=off
      export GOSUMDB=off
      cd "$modRoot"
    '' + lib.optionalString hasAnyVendorHash ''
      ${if finalAttrs.proxyVendor then ''
        export GOPROXY=file://${finalAttrs.go-modules}
      '' else ''
        rm -rf vendor
        cp -r --reflink=auto ${finalAttrs.go-modules} vendor
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

    inherit allowGoReference;
    disallowedReferences = lib.optional (!finalAttrs.allowGoReference) go;

    passthru = {
      inherit go;
    } // passthru;

    meta = {
      # Add default meta information
      platforms = go.meta.platforms or lib.platforms.all;
    } // meta;

    # For assertions
    inherit
      buildFlags
      buildFlagsArray
      goPackagePath
      ;
  }
) (if lib.isFunction rattrs then rattrs finalAttrs else rattrs)

)).overrideAttrs (finalAttrs: previousAttrs: {
  # Assertions
  go-modules =
    # Assert that either vendorHash or vendorSha256 is set.
    assert finalAttrs.vendorHash == "_unset" && finalAttrs.vendorSha256 == "_unset" -> throw
      "both `vendorHash` and `vendorSha256` set. only one can be set.";
    assert finalAttrs.goPackagePath != "" -> throw
      "`goPackagePath` is not needed with `buildGoModule`";
    lib.warnIf (finalAttrs.buildFlags != null || finalAttrs.buildFlagsArray != null)
      "Use the `ldflags` and/or `tags` attributes instead of `buildFlags`/`buildFlagsArray`"
      previousAttrs.go-modules;
})
