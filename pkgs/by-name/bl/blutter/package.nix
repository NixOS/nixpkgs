{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
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

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      pyelftools
      requests
    ]
  );

  pkgConfigPath = lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
    icu
    capstone
  ];

  cmakePrefixPath = lib.makeSearchPath "" [
    (lib.getDev icu)
    (lib.getLib icu)
    (lib.getDev capstone)
    (lib.getLib capstone)
  ];

  cmakeLibraryPath = lib.makeLibraryPath [
    icu
    capstone
  ];

  cmakeIncludePath = lib.makeSearchPathOutput "dev" "include" [
    icu
    capstone
  ];

  capstoneCompatInclude = "${lib.getDev capstone}/include/capstone";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blutter";
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "worawit";
    repo = "blutter";
    rev = "129377f65dffecd59535eb35041de534c4dea2ea";
    hash = "sha256-88ErOUjzXrUtxpK7wmoo2nhyByf5mU+f3BbScI3BsCA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/blutter
    cp -r . $out/share/blutter
    chmod -R u+w $out/share/blutter

    mkdir -p $out/bin
    cat > $out/bin/blutter <<'EOF'
    #!${stdenvNoCC.shell}
    set -euo pipefail

    stateRoot="''${XDG_STATE_HOME:-$HOME/.local/state}/blutter"
    workDir="$stateRoot/${finalAttrs.version}"

    if [ ! -d "$workDir" ]; then
      mkdir -p "$stateRoot"
      cp -r "${placeholder "out"}/share/blutter" "$workDir"
      chmod -R u+w "$workDir"
    fi

    export PATH="${
      lib.makeBinPath [
        git
        cmake
        ninja
        pkg-config
        gcc
      ]
    }:$PATH"
    export PKG_CONFIG_PATH="${pkgConfigPath}''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
    export CMAKE_PREFIX_PATH="${cmakePrefixPath}''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
    export CMAKE_LIBRARY_PATH="${cmakeLibraryPath}''${CMAKE_LIBRARY_PATH:+:$CMAKE_LIBRARY_PATH}"
    export CMAKE_INCLUDE_PATH="${cmakeIncludePath}''${CMAKE_INCLUDE_PATH:+:$CMAKE_INCLUDE_PATH}"
    export LD_LIBRARY_PATH="${cmakeLibraryPath}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export ICU_ROOT="${lib.getDev icu}"
    export CPPFLAGS="-I${capstoneCompatInclude} ''${CPPFLAGS:-}"
    export CXXFLAGS="-I${capstoneCompatInclude} ''${CXXFLAGS:-}"

    exec "${pythonEnv}/bin/python" "$workDir/blutter.py" "$@"
    EOF
    chmod +x $out/bin/blutter

    runHook postInstall
  '';

  passthru.tests.smoke = runCommand "blutter-smoke" { } ''
    export HOME="$TMPDIR"
    export XDG_STATE_HOME="$TMPDIR/.local/state"
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
