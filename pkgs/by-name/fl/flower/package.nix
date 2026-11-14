{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitea,
  fetchurl,
  clojure,
  graalvmPackages,
  coreutils,
  makeWrapper,
  dart-sass,
  python3Packages,
  git,
  cmake,
  gtest,
  zlib,
  cacert,
}:

let
  pname = "flower";
  version = "0-unstable-2026-05-07";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jyn514";
    repo = "flower";
    rev = "7a6b6096451ee5f5954bd852ae1c048e0b17b921";
    hash = "sha256-Ua66kkqS6Itafl+GZqrJWiCA6eU2eOTI+JYA/6RZZhA=";
  };

  # Flower's build uses a patched Ninja feature that is not in nixpkgs' Ninja.
  # Fetch the exact revision it would otherwise clone during the build.
  ninjaSrc = fetchFromGitHub {
    owner = "ninja-build";
    repo = "ninja";
    rev = "bee2e3943ca5d853a6ea7a2091e88b5149ced9cf";
    hash = "sha256-meb5gtUWt8LI+gqxVN3+nxlDsbQJXevsPcUWlYrzhf8=";
  };

  # Ninja 1.13's CMake build downloads GoogleTest for the `ninja_test`
  # binary required by Flower's native build. Supply the pinned archive so
  # CMake does not attempt a network fetch in the sandbox.
  googletestTarball = fetchurl {
    url = "https://github.com/google/googletest/releases/download/v1.16.0/googletest-1.16.0.tar.gz";
    hash = "sha256-eMZ2/GOIFSm/l7+dRZSNkFpmgz+/pTGOos10eMuY85k=";
  };

  # Pre-download Clojure dependencies into a Fixed-Output Derivation.
  deps = stdenv.mkDerivation {
    pname = "flower-deps";
    inherit version src;
    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [
      clojure
      git
      cacert
    ];

    buildPhase = ''
      export HOME="$(pwd)"
      export _JAVA_OPTIONS="-Duser.home=$HOME -Xmx2g"
      export GITLIBS="$HOME/.gitlibs"

      set -e

      clojure -P
      clojure -P -T:build
      clojure -P -M:dev:test

      # The generated comment timestamps vary across builds; they are ignored
      # by Maven, so remove them while preserving repository provenance.
      find "$HOME/.m2" -type f -name _remote.repositories -exec sed -i '/^#/d' {} +

      # Gitlibs clones mirrors, including mutable refs/pull/* refs. Keep only
      # the exact commits used by cached worktrees so new upstream refs cannot
      # change this fixed-output dependency cache. Build one canonical pack
      # from a sorted object list; repack can otherwise preserve input pack
      # ordering even when deltas and reuse are disabled.
      find "$HOME/.gitlibs/_repos" -type f -name config -print0 \
        | while IFS= read -r -d "" config; do
          repo="$(dirname "$config")"
          heads="$(mktemp)"
          objects="$(mktemp)"
          packdir="$(mktemp -d)"

          # Record worktree HEADs before deleting fetched refs; a worktree
          # may be detached at a commit that has no named upstream ref.
          for headFile in "$repo"/worktrees/*/HEAD; do
            [ -f "$headFile" ] || continue
            head="$(cat "$headFile")"
            case "$head" in
              "ref: "*) head="$(git -C "$repo" rev-parse --verify "''${head#ref: }^{commit}")" ;;
            esac
            git -C "$repo" cat-file -e "$head^{commit}"
            printf '%s\n' "$head" >> "$heads"
          done

          sort -u -o "$heads" "$heads"
          if [ ! -s "$heads" ]; then
            echo "No cached worktree commits found in $repo" >&2
            exit 1
          fi

          set --
          while IFS= read -r head; do
            set -- "$@" "$head"
          done < "$heads"
          git -C "$repo" rev-list --objects --no-object-names "$@" \
            | LC_ALL=C sort -u > "$objects"

          git -C "$repo" for-each-ref --format='delete %(refname)' \
            | git -C "$repo" update-ref --stdin
          while IFS= read -r head; do
            git -C "$repo" update-ref "refs/nixpkgs-gitlibs/$head" "$head"
          done < "$heads"

          # Pack only pinned commit closures; prune removes unreachable objects.
          # pack-objects reads the sorted
          # object IDs verbatim, disables existing object reuse and deltas, and
          # emits no optional reverse-index or bitmap sidecars.
          git -C "$repo" reflog expire --expire=now --all
          packHash="$(git -C "$repo" pack-objects --no-reuse-object --no-reuse-delta \
            --threads=1 --window=0 --depth=0 --compression=9 \
            "$packdir/pack" < "$objects")"
          rm -f "$repo"/objects/pack/*
          mv "$packdir/pack-$packHash.pack" "$repo/objects/pack/pack-$packHash.pack"
          mv "$packdir/pack-$packHash.idx" "$repo/objects/pack/pack-$packHash.idx"
          while IFS= read -r head; do
            git -C "$repo" cat-file -e "$head^{commit}"
          done < "$heads"
          rm -rf "$packdir" "$heads" "$objects"
          # info/refs caches the server's mutable advertised refs; it is not
          # needed to use the pinned cached worktree offline.
          rm -f "$repo/objects/info/packs" "$repo/info/refs"
          git -C "$repo" prune --expire=now

          # Make both worktree backlinks relative; Gitlibs otherwise embeds
          # the fixed-output builder's /build/source path in the cache.
          for worktreeAdmin in "$repo"/worktrees/*; do
            [ -f "$worktreeAdmin/HEAD" ] || continue
            worktreeId="$(basename "$worktreeAdmin")"
            find "$HOME/.gitlibs/libs" -type d -name "$worktreeId" -print0 \
              | while IFS= read -r -d "" worktree; do
                [ -f "$worktree/.git" ] || continue
                git -C "$repo" worktree repair --relative-paths "$worktree"
              done
          done
        done
    '';

    installPhase = ''
      mkdir -p $out
      [ -d $HOME/.m2 ] && cp -a $HOME/.m2 $out/
      if [ -d $HOME/.gitlibs ]; then
        # Git initializes these sample hooks using scripts patched to the
        # builder's bash and perl store paths. The cached dependency repos do
        # not need hooks when they are restored for the offline package build.
        find $HOME/.gitlibs -type d -name hooks -prune -exec rm -rf {} +
        cp -a $HOME/.gitlibs $out/
        # Worktree indexes contain filesystem stat-cache data (inode and
        # timestamps), which changes between otherwise identical builds. The
        # cached source trees and Git metadata remain sufficient for the
        # offline build; the index is regenerated by Git if it is ever needed.
        find $out/.gitlibs -path '*/worktrees/*/index' -type f -delete
      fi

    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-vhhD8wPr5Wmu0kE4raJbLtmaLd9XplsYmrwYn72x+ZQ=";
  };

in
stdenv.mkDerivation {
  inherit pname version src;
  passthru.deps = deps;
  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace native.clj \
      --replace-fail '(def GIT-HASH (->> "describe --always" (str git " ")' '(def GIT-HASH (or (System/getenv "FLOWER_GIT_HASH") (->> "describe --always" (str git " ")' \
      --replace-fail ':out str/trimr))' ':out str/trimr)))' \
      --replace-fail '(run "cmake -B build --log-level=WARNING -DCMAKE_RULE_MESSAGES=OFF")' '(run "cmake -B build --log-level=WARNING -DCMAKE_RULE_MESSAGES=OFF" (str "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=" (System/getenv "GOOGLETEST_SRC")))'
  '';

  FLOWER_GIT_HASH = "7a6b6096451ee5f5954bd852ae1c048e0b17b921";

  nativeBuildInputs = [
    clojure
    graalvmPackages.graalvm-ce
    coreutils
    makeWrapper
    git
    cmake
    gtest
    cacert
  ];

  buildInputs = [
    zlib
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$(pwd)"
    export _JAVA_OPTIONS="-Duser.home=$HOME"
    export GITLIBS="$HOME/.gitlibs"

    # Restore cached Clojure dependencies
    [ -d ${deps}/.m2 ] && cp -R ${deps}/.m2 $HOME/
    [ -d ${deps}/.gitlibs ] && cp -R ${deps}/.gitlibs $HOME/
    chmod -R u+w $HOME/.m2 $HOME/.gitlibs || true

    # Provide a dummy git repository. `native.clj` uses `git describe --always`
    # and expects a tracked `defaults` folder to generate `MANIFEST.txt`.
    git init -b main || git init
    git config user.name "Nix Build"
    git config user.email "nix-build@localhost"
    git add .
    git commit -m "Dummy commit"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p target
    cp -R ${ninjaSrc} target/ninja
    chmod -R u+w target/ninja

    # Ninja's Linux SubprocessTest.SetWithLots hardcodes /bin/echo, which is
    # absent in NixOS builders. Keep the test enabled but point it at the
    # declared coreutils input.
    substituteInPlace target/ninja/src/subprocess_test.cc \
      --replace-fail 'Add("/bin/echo")' 'Add("${coreutils}/bin/echo")'

    mkdir -p "$TMPDIR/googletest"
    tar -xzf ${googletestTarball} --strip-components=1 -C "$TMPDIR/googletest"

    # Setting CI=true triggers `--parallelism=4` and `-J-Xmx4g` in `native.clj`,
    # preventing GraalVM from exhausting memory.
    export CI=true
    export GOOGLETEST_SRC="$TMPDIR/googletest"

    # Passing `:include-untracked true` ensures `MANIFEST.txt` contains all default files
    # even if git tracking is slightly off due to our dummy repo initialization.
    clojure -T:build native :include-untracked true

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 target/flower $out/bin/flower
    wrapProgram $out/bin/flower \
      --prefix PATH : ${
        lib.makeBinPath [
          dart-sass
          python3Packages.pygments
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Static site generator that grows with you";
    homepage = "https://flower.jyn.dev";
    changelog = "https://codeberg.org/jyn514/flower/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "flower";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
  };
}
