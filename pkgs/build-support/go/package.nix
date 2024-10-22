{ go, govers, lib, fetchgit, fetchhg, fetchbzr, rsync
, fetchFromGitHub, stdenv }:

{ buildInputs ? []
, nativeBuildInputs ? []
, passthru ? {}
, preFixup ? ""
, shellHook ? ""

# We want parallel builds by default
, enableParallelBuilding ? true

# Go import path of the package
, goPackagePath

# Go package aliases
, goPackageAliases ? [ ]

# Extra sources to include in the gopath
, extraSrcs ? [ ]

# Extra gopaths containing src subfolder
# with sources to include in the gopath
, extraSrcPaths ? [ ]

# go2nix dependency file
, goDeps ? null

# Whether to delete the vendor folder supplied with the source.
, deleteVendor ? false

, dontRenameImports ? false

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, CGO_ENABLED ? go.CGO_ENABLED

, ldflags ? [ ]

, GOFLAGS ? [ ]

# needed for buildFlags{,Array} warning
, buildFlags ? ""
, buildFlagsArray ? ""

, meta ? {}, ... } @ args:

let
  dep2src = goDep:
    {
      inherit (goDep) goPackagePath;
      src = if goDep.fetch.type == "git" then
        fetchgit {
          inherit (goDep.fetch) url rev sha256;
        }
      else if goDep.fetch.type == "hg" then
        fetchhg {
          inherit (goDep.fetch) url rev sha256;
        }
      else if goDep.fetch.type == "bzr" then
        fetchbzr {
          inherit (goDep.fetch) url rev sha256;
        }
      else if goDep.fetch.type == "FromGitHub" then
        fetchFromGitHub {
          inherit (goDep.fetch) owner repo rev sha256;
        }
      else abort "Unrecognized package fetch type: ${goDep.fetch.type}";
    };

  importGodeps = { depsFile }:
    map dep2src (import depsFile);

  goPath = if goDeps != null then importGodeps { depsFile = goDeps; } ++ extraSrcs
                             else extraSrcs;
  package = stdenv.mkDerivation (
    (builtins.removeAttrs args [ "goPackageAliases" "disabled" "extraSrcs"]) // {

    nativeBuildInputs = [ go ]
      ++ (lib.optional (!dontRenameImports) govers) ++ nativeBuildInputs;
    buildInputs = buildInputs;

    inherit (go) GOOS GOARCH GO386;

    GOHOSTARCH = go.GOHOSTARCH or null;
    GOHOSTOS = go.GOHOSTOS or null;

    inherit CGO_ENABLED enableParallelBuilding;

    GO111MODULE = "off";
    GOTOOLCHAIN = "local";
    GOFLAGS = GOFLAGS ++ lib.optional (!allowGoReference)  "-trimpath" ;

    GOARM = toString (lib.intersectLists [(stdenv.hostPlatform.parsed.cpu.version or "")] ["5" "6" "7"]);

    # If not set to an explicit value, set the buildid empty for reproducibility.
    ldflags = ldflags ++ lib.optional (!lib.any (lib.hasPrefix "-buildid=") ldflags) "-buildid=";

    configurePhase = args.configurePhase or (''
      runHook preConfigure

      # Extract the source
      cd "$NIX_BUILD_TOP"
      mkdir -p "go/src/$(dirname "$goPackagePath")"
      mv "$sourceRoot" "go/src/$goPackagePath"

    '' + lib.optionalString deleteVendor ''
      if [ ! -d "go/src/$goPackagePath/vendor" ]; then
        echo "vendor folder does not exist, 'deleteVendor' is not needed"
        exit 10
      else
        rm -rf "go/src/$goPackagePath/vendor"
      fi
    '' + lib.optionalString (goDeps != null) ''
      if [ -d "go/src/$goPackagePath/vendor" ]; then
        echo "vendor folder exists, 'goDeps' is not needed"
        exit 10
      fi
    '' + lib.flip lib.concatMapStrings goPath ({ src, goPackagePath }: ''
      mkdir goPath
      (cd goPath; unpackFile "${src}")
      mkdir -p "go/src/$(dirname "${goPackagePath}")"
      chmod -R u+w goPath/*
      mv goPath/* "go/src/${goPackagePath}"
      rmdir goPath

    '') + (lib.optionalString (extraSrcPaths != []) ''
      ${rsync}/bin/rsync -a ${lib.concatMapStringsSep " " (p: "${p}/src") extraSrcPaths} go

    '') + ''
      export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
      export GOCACHE=$TMPDIR/go-cache

      # currently pie is only enabled by default in pkgsMusl
      # this will respect the `hardening{Disable,Enable}` flags if set
      if [[ $NIX_HARDENING_ENABLE =~ "pie" ]]; then
        export GOFLAGS="-buildmode=pie $GOFLAGS"
      fi

      runHook postConfigure
    '');

    renameImports = args.renameImports or (
      let
        inputsWithAliases = lib.filter (x: x ? goPackageAliases)
          (buildInputs ++ (args.propagatedBuildInputs or [ ]));
        rename = to: from: "echo Renaming '${from}' to '${to}'; govers -d -m ${from} ${to}";
        renames = p: lib.concatMapStringsSep "\n" (rename p.goPackagePath) p.goPackageAliases;
      in lib.concatMapStringsSep "\n" renames inputsWithAliases);

    buildPhase = args.buildPhase or (''
      runHook preBuild

      runHook renameImports

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
          echo "$subPackages" | sed "s,\(^\| \),\1$goPackagePath/,g"
        else
          pushd "$NIX_BUILD_TOP/go/src" >/dev/null
          find "$goPackagePath" -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort | uniq | grep -v "$exclude"
          popd >/dev/null
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
        dir=$NIX_BUILD_TOP/go/bin/${go.GOOS}_${go.GOARCH}
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

    doCheck = args.doCheck or false;
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
      dir="$NIX_BUILD_TOP/go/bin"
      [ -e "$dir" ] && cp -r $dir $out

      runHook postInstall
    '';

    strictDeps = true;

    shellHook = ''
      d=$(mktemp -d "--suffix=-$name")
    '' + toString (map (dep: ''
       mkdir -p "$d/src/$(dirname "${dep.goPackagePath}")"
       ln -s "${dep.src}" "$d/src/${dep.goPackagePath}"
    ''
    ) goPath) + ''
      export GOPATH=${lib.concatStringsSep ":" ( ["$d"] ++ ["$GOPATH"] ++ ["$PWD"] ++ extraSrcPaths)}
    '' + shellHook;

    disallowedReferences = lib.optional (!allowGoReference) go
      ++ lib.optional (!dontRenameImports) govers;

    passthru = passthru //
      { inherit go; } //
      lib.optionalAttrs (goPackageAliases != []) { inherit goPackageAliases; };

    meta = {
      # Add default meta information
      homepage = "https://${goPackagePath}";
      platforms = go.meta.platforms or lib.platforms.all;
    } // meta;
  });
in
lib.warnIf (buildFlags != "" || buildFlagsArray != "")
  "`buildFlags`/`buildFlagsArray` are deprecated and will be removed in the 24.11 release. Use the `ldflags` and/or `tags` attributes instead"
lib.warnIf (builtins.elem "-buildid=" ldflags) "`-buildid=` is set by default as ldflag by buildGoModule"
lib.warnIf (builtins.elem "-trimpath" GOFLAGS) "`-trimpath` is added by default to GOFLAGS by buildGoModule when allowGoReference isn't set to true"
lib.warn '''buildGoPackage' is deprecated and will be removed for the 25.05 release.
Please use 'buildGoModule' instead. Tips for migration can be found in the Go section of the nixpkgs manual.''
  package
