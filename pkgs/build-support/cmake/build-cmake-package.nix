/**
  buildCMakePackage: stdenv.mkDerivation-shaped helper for CMake projects that
  pull Git (or similar) content via ExternalProject / FetchContent.

  Like buildGoModule + vendorHash: a fixed-output `cmakeDeps` derivation runs
  CMake only far enough to download content; the main build stays offline.

  Offline wiring (no ad-hoc path rewrites in package expressions when possible):
  - FetchContent: FETCHCONTENT_SOURCE_DIR_<NAME> → cmakeDeps/<name>
  - ExternalProject: rewrite GIT_REPOSITORY to SOURCE_DIR → cmakeDeps/<name>
    (placement alone is not enough: EP still runs `git fetch` on update)
  - Also symlink cmakeDeps into $cmakeBuildDir/<name>/src/<name> so relative
    layouts like ${LEAN_BINARY_DIR}/../<name>/src/<name> resolve without edits

  Packages that do not use CMake content fetching should keep using
  `stdenv.mkDerivation` with `nativeBuildInputs = [ cmake ]` unchanged.

  cmakeDepsHash: SRI hash of the content FOD (defaults to lib.fakeHash + warning).
  externalTargets: CMake targets to build in the FOD (download step).
  contentGitRepositories: name → GIT_REPOSITORY URL (for ExternalProject SOURCE_DIR).
*/
{
  lib,
  stdenv,
  cmake,
  git,
  cacert,
  pkg-config,
  removeReferencesTo,
  bash,
  perl,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "cmakeDepsBuildInputs"
    "cmakeDepsNativeBuildInputs"
    "contentGitRepositories"
    "cmakeDepsStripDotGit"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      nativeBuildInputs ? [ ],
      passthru ? { },
      preConfigure ? "",
      postConfigure ? "",
      preBuild ? "",

      cmakeDepsHash ? lib.warn "buildCMakePackage: cmakeDepsHash is missing; using lib.fakeHash so the build can report the correct SRI hash" lib.fakeHash,

      externalTargets ? [ ],

      /**
        Map content name → exact `GIT_REPOSITORY <url>` string in CMakeLists.
        Used only to switch ExternalProject to SOURCE_DIR (EP always wants git
        otherwise). Prefer listing the same names as externalTargets.
      */
      contentGitRepositories ? { },

      cmakeDepsBuildInputs ? [ ],
      cmakeDepsNativeBuildInputs ? [ ],

      /**
        If true, remove `.git` from the content FOD (more stable hash, but ExternalProject
        update steps that expect a real clone will fail). Default false so placement /
        git-based EP update can work offline with a real checkout.
      */
      cmakeDepsStripDotGit ? false,

      ...
    }@args:

    let
      inherit (lib) optionalString escapeShellArg escapeShellArgs;

      userPostPatch = args.postPatch or "";
      userPrePatch = args.prePatch or "";
      userPatches = args.patches or [ ];
      userPatchFlags = args.patchFlags or [ ];
      userCmakeFlags = args.cmakeFlags or [ ];
      userPreConfigure = args.preConfigure or "";
      userPostConfigure = args.postConfigure or "";
      userPreBuild = args.preBuild or "";

      pname = finalAttrs.pname or "package";
      version = finalAttrs.version or "";
      nameSuffix = optionalString (version != "") "-${version}";

      # FOD outputs must not retain store references. Keeping `.git` often embeds
      # paths to the git/bash/perl used during the clone unless we scrub them.
      scrubRefs = [
        cmake
        git
        cacert
        pkg-config
        bash
        perl
        stdenv.cc
        stdenv.cc.bintools
      ]
      ++ cmakeDepsNativeBuildInputs
      ++ cmakeDepsBuildInputs;

      contentNames =
        if externalTargets != [ ] then externalTargets else lib.attrNames contentGitRepositories;

      cmakeDeps = stdenv.mkDerivation {
        name = "${pname}-cmake-deps${nameSuffix}";

        outputs = [ "out" ];

        inherit (finalAttrs) src;

        sourceRoot = finalAttrs.sourceRoot or null;
        setSourceRoot = finalAttrs.setSourceRoot or null;
        preUnpack = finalAttrs.preUnpack or "";
        unpackPhase = finalAttrs.unpackPhase or null;
        postUnpack = finalAttrs.postUnpack or "";

        prePatch = userPrePatch;
        patches = userPatches;
        patchFlags = userPatchFlags;
        postPatch = userPostPatch;

        nativeBuildInputs = [
          cmake
          git
          cacert
          pkg-config
          removeReferencesTo
        ]
        ++ cmakeDepsNativeBuildInputs;

        buildInputs = cmakeDepsBuildInputs;

        nativeCheckInputs = [ ];
        checkInputs = [ ];
        doCheck = false;
        dontConfigure = true;
        dontFixup = true;
        postInstall = null;
        preInstall = null;
        preConfigure = null;
        postConfigure = null;
        preBuild = null;
        postBuild = null;
        passthru = { };

        outputHashMode = "recursive";
        outputHash = finalAttrs.cmakeDepsHash;
        outputHashAlgo = null;

        meta = (finalAttrs.meta or { }) // {
          description = "CMake FetchContent/ExternalProject sources for ${pname}";
          hydraPlatforms = [ ];
        };

        buildPhase = ''
          runHook preBuild

          mkdir -p build
          cd build

          cmakeFlagsArray=( ${escapeShellArgs userCmakeFlags} )
          cmake .. "''${cmakeFlagsArray[@]}" -DCMAKE_BUILD_TYPE="''${cmakeBuildType:-Release}"

          ${lib.concatMapStringsSep "\n" (target: ''
            echo "buildCMakePackage: fetching content target ${target}"
            cmake --build . --target ${escapeShellArg target}
          '') externalTargets}

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p "$out"
          found=

          copyContent() {
            local name="$1"
            local srcdir=""
            if [ -d "$name/src/$name" ]; then
              srcdir="$name/src/$name"
            elif [ -d "_deps/$name-src" ]; then
              srcdir="_deps/$name-src"
            else
              return 1
            fi
            rm -rf "$out/$name"
            cp -a "$srcdir" "$out/$name"
            found=1
          }

          ${
            if contentNames != [ ] then
              lib.concatMapStringsSep "\n" (name: ''
                if ! copyContent ${escapeShellArg name}; then
                  echo "buildCMakePackage: missing sources for content ${name}" >&2
                  find . -maxdepth 4 -type d | head -80 >&2 || true
                  exit 1
                fi
              '') contentNames
            else
              ''
                if [ -d _deps ]; then
                  for d in _deps/*-src; do
                    [ -d "$d" ] || continue
                    name=$(basename "$d")
                    name=''${name%-src}
                    copyContent "$name" || true
                  done
                fi
                for d in */src/*/; do
                  [ -d "$d" ] || continue
                  name=$(basename "$d")
                  parent=$(basename "$(dirname "$(dirname "$d")")")
                  case "$name" in
                    *-stamp|*-build|tmp|CMakeFiles) continue ;;
                  esac
                  [ "$parent" = "$name" ] || continue
                  copyContent "$name" || true
                done
              ''
          }

          if [ -z "$found" ]; then
            echo "buildCMakePackage: no FetchContent/ExternalProject sources found under $PWD" >&2
            find . -maxdepth 4 \( -type d -o -type f \) | head -100 >&2 || true
            exit 1
          fi

          ${lib.optionalString cmakeDepsStripDotGit ''
            # Optional: drop VCS metadata for a more portable FOD hash. Disabled by
            # default so ExternalProject can treat the tree as a normal git checkout.
            find "$out" -name .git -prune -exec rm -rf {} +
          ''}

          # Sample hooks and absolute tool paths inside .git must not appear in a FOD.
          find "$out" -path '*/.git/hooks/*' -type f -delete 2>/dev/null || true

          ${lib.concatMapStringsSep "\n" (p: ''
            find "$out" -type f -exec remove-references-to -t ${lib.getBin p} {} + 2>/dev/null || true
            find "$out" -type f -exec remove-references-to -t ${p} {} + 2>/dev/null || true
          '') scrubRefs}

          runHook postInstall
        '';
      };

      # Symlink FOD into the default ExternalProject PREFIX layout so relative
      # references (${LEAN_BINARY_DIR}/../name/src/name) work without edits.
      seedLayoutScript = optionalString (contentNames != [ ]) ''
        if [ -f CMakeCache.txt ]; then
          _cmakeContentRoot=.
        else
          _cmakeContentRoot="''${cmakeBuildDir:-build}"
        fi
        ${lib.concatMapStringsSep "\n" (name: ''
          echo "buildCMakePackage: linking ${name} into $_cmakeContentRoot/${name}/src/${name}"
          mkdir -p "$_cmakeContentRoot/${name}/src"
          rm -rf "$_cmakeContentRoot/${name}/src/${name}"
          ln -sfn "${finalAttrs.cmakeDeps}/${name}" "$_cmakeContentRoot/${name}/src/${name}"
        '') contentNames}
      '';
    in
    {
      inherit cmakeDepsHash externalTargets;

      inherit cmakeDeps;

      postPatch =
        userPostPatch
        # ExternalProject: SOURCE_DIR disables download/update (placement alone does not).
        + lib.concatStrings (
          lib.mapAttrsToList (name: repo: ''
            while IFS= read -r -d ''' f; do
              if grep -qF 'GIT_REPOSITORY ${repo}' "$f" 2>/dev/null; then
                substituteInPlace "$f" \
                  --replace-fail 'GIT_REPOSITORY ${repo}' 'SOURCE_DIR "${finalAttrs.cmakeDeps}/${name}"'
                sed -i '/GIT_TAG /d' "$f"
              fi
            done < <(find . -name CMakeLists.txt -print0 2>/dev/null)
          '') contentGitRepositories
        );

      preConfigure = userPreConfigure;

      postConfigure = userPostConfigure + seedLayoutScript;

      preBuild = userPreBuild + seedLayoutScript;

      cmakeFlags =
        userCmakeFlags
        ++ lib.concatMap (
          name:
          let
            uname = lib.toUpper name;
          in
          [
            "-DFETCHCONTENT_SOURCE_DIR_${uname}=${finalAttrs.cmakeDeps}/${name}"
          ]
        ) contentNames
        ++ lib.optionals (contentNames != [ ]) [
          "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
        ];

      nativeBuildInputs = [
        cmake
      ]
      ++ nativeBuildInputs;

      passthru = passthru // {
        inherit (finalAttrs) cmakeDeps cmakeDepsHash;
      };
    };
}
