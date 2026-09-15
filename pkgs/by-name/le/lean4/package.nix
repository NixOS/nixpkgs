{
  lib,
  stdenv,
  cmake,
  cctools,
  fetchFromGitHub,
  git,
  gmp,
  cadical,
  leangz,
  makeWrapper,
  pkg-config,
  libuv,
  enableMimalloc ? true,
  perl,
  testers,
  gitUpdater,
  nix,
  nix-prefetch-git,
  nix-prefetch-github,
  cacert,
  gnumake,
  writers,
  _experimental-update-script-combinators,
}:
let
  contentSpecs = lib.importJSON ./cmake-content.json;
  content = lib.mapAttrs (
    _name: spec:
    fetchFromGitHub {
      inherit (spec)
        owner
        repo
        tag
        hash
        ;
    }
  ) contentSpecs;

  cadical' = cadical.override {
    version = builtins.replaceStrings [ "rel-" ] [ "" ] contentSpecs.cadical.tag;
  };

  updateCMakeContent = writers.writePython3 "lean4-update-cmake-content" {
    flakeIgnore = [ "E501" ];
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        nix
        nix-prefetch-git
        nix-prefetch-github
        cmake
        git
        cacert
        gnumake
        stdenv.cc
        pkg-config
        gmp
        cadical'
      ])
    ];
  } ./update-cmake-content.py;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.31.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-up4Juc/IyMuggGLMSDgwYEOoMk/K5U8NI0jzeAKqhO0=";
  };

  postPatch =
    let
      mimallocPathPattern = "\${LEAN_BINARY_DIR}/../mimalloc/src/mimalloc";
    in
    ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${finalAttrs.src.tag}")'

      rm -rf src/lake/examples/git/
    ''
    + lib.optionalString (enableMimalloc && content ? mimalloc) ''
      # ExternalProject (Lean ≤4.30): pin SOURCE_DIR. FetchContent (≥4.31): cmakeFlags only.
      if grep -qE 'ExternalProject_Add[[:space:]]*\([[:space:]]*mimalloc' CMakeLists.txt; then
        substituteInPlace CMakeLists.txt \
          --replace-fail 'GIT_REPOSITORY https://github.com/${contentSpecs.mimalloc.owner}/${contentSpecs.mimalloc.repo}' \
                         'SOURCE_DIR "${content.mimalloc}"' \
          --replace-fail 'GIT_TAG ${contentSpecs.mimalloc.tag}' ""
      fi

      for file in stage0/src/CMakeLists.txt stage0/src/runtime/CMakeLists.txt src/CMakeLists.txt src/runtime/CMakeLists.txt; do
        substituteInPlace "$file" \
          --replace-fail '${mimallocPathPattern}' '${content.mimalloc}'
      done
    '';

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    leangz
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ];

  buildInputs = [
    gmp
    libuv
    cadical'
  ];

  postInstall = ''
    wrapProgram $out/bin/lean \
      --prefix PATH : ${cadical'}/bin
  '';

  nativeCheckInputs = [
    git
    perl
  ];

  cmakeFlags = [
    "-DUSE_GITHASH=OFF"
    "-DINSTALL_LICENSE=OFF"
    "-DINSTALL_CADICAL=OFF"
    "-DUSE_MIMALLOC=${if enableMimalloc then "ON" else "OFF"}"
  ]
  ++ lib.optionals (enableMimalloc && content ? mimalloc) [
    "-DFETCHCONTENT_SOURCE_DIR_MIMALLOC=${content.mimalloc}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  passthru = {
    inherit content;
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "v${finalAttrs.version}";
      };
    };
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater {
        rev-prefix = "v";
        ignoredVersions = "-rc";
      })
      {
        command = [ updateCMakeContent ];
        supportedFeatures = [ "silent" ];
      }
    ];
  };

  meta = {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      danielbritten
      jthulhu
      nadja-y
      niklashh
    ];
    mainProgram = "lean";
  };
})
