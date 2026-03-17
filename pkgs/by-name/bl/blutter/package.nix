{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  runCommand,
  git,
  cmake,
  ninja,
  pkg-config,
  gcc,
  icu,
  capstone,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blutter";
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "worawit";
    repo = "blutter";
    rev = "129377f65dffecd59535eb35041de534c4dea2ea";
    hash = "sha256-88ErOUjzXrUtxpK7wmoo2nhyByf5mU+f3BbScI3BsCA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/blutter
    cp -r . $out/share/blutter
    chmod -R u+w $out/share/blutter

    mkdir -p $out/bin
    makeWrapper ${
      python3.withPackages (
        ps: with ps; [
          pyelftools
          requests
        ]
      )
    }/bin/python $out/bin/blutter \
      --add-flags "$out/share/blutter/blutter.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          cmake
          ninja
          pkg-config
          gcc
        ]
      } \
      --prefix PKG_CONFIG_PATH : ${
        lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
          icu
          capstone
        ]
      } \
      --prefix CMAKE_PREFIX_PATH : ${
        lib.makeSearchPath "" [
          (lib.getDev icu)
          (lib.getLib icu)
          (lib.getDev capstone)
          (lib.getLib capstone)
        ]
      } \
      --prefix CMAKE_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          icu
          capstone
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          icu
          capstone
        ]
      } \
      --prefix CMAKE_INCLUDE_PATH : ${
        lib.makeSearchPathOutput "dev" "include" [
          icu
          capstone
        ]
      } \
      --set ICU_ROOT ${lib.getDev icu} \
      --run 'export CPPFLAGS="-I${lib.getDev capstone}/include/capstone ''${CPPFLAGS:-}"' \
      --run 'export CXXFLAGS="-I${lib.getDev capstone}/include/capstone ''${CXXFLAGS:-}"'

    runHook postInstall
  '';

  passthru.tests.smoke = runCommand "blutter-smoke" { } ''
    ${finalAttrs.finalPackage}/bin/blutter --help >/dev/null
    touch $out
  '';

  meta = {
    description = "Flutter Mobile Application Reverse Engineering Tool";
    homepage = "https://github.com/worawit/blutter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ huanghunr ];
    platforms = lib.platforms.linux;
    mainProgram = "blutter";
  };
})
