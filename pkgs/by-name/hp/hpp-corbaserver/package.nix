{
  lib,
  fetchFromGitHub,
  runCommand,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  omniorb,
  pkg-config,
  python3Packages,

  # propagatedBuildInputs
  hpp-core,
  hpp-template-corba,
  makeWrapper,

  # checkInputs
  psmisc,
}:

let
  hpp-corbaserver = stdenv.mkDerivation (finalAttrs: {
    pname = "hpp-corbaserver";
    version = "6.0.0";

    src = fetchFromGitHub {
      owner = "humanoid-path-planner";
      repo = "hpp-corbaserver";
      tag = "v${finalAttrs.version}";
      hash = "sha256-1snnRFRgg+5LWtDBBmtqPE3YBqjDIct+2mfEIKd6ow8=";
    };

    prePatch = ''
      substituteInPlace tests/hppcorbaserver.sh \
        --replace-fail /bin/bash ${stdenv.shell}
    '';

    outputs = [
      "out"
      "doc"
    ];

    nativeBuildInputs = [
      cmake
      doxygen
      omniorb
      pkg-config
      python3Packages.pythonImportsCheckHook
    ];
    propagatedBuildInputs = [
      hpp-core
      hpp-template-corba
      python3Packages.omniorbpy
      python3Packages.numpy
    ];
    checkInputs = [
      psmisc
    ];

    enableParallelBuilding = false;

    # psmisc is only available on linux
    doCheck = stdenv.isLinux;

    pythonImportsCheck = [ "hpp.corbaserver" ];

    passthru.withPlugins =
      plugins:
      runCommand "hppcorbaserver" { nativeBuildInputs = [ makeWrapper ]; } ''
        makeWrapper ${lib.getExe hpp-corbaserver} $out/bin/hppcorbaserver \
          --set HPP_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
      '';

    meta = {
      description = "Corba server for Humanoid Path Planner applications";
      homepage = "https://github.com/humanoid-path-planner/hpp-corbaserver";
      changelog = "https://github.com/humanoid-path-planner/hpp-corbaserver/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.bsd2;
      maintainers = [ lib.maintainers.nim65s ];
      mainProgram = "hppcorbaserver";
      platforms = lib.platforms.unix;
    };
  });
in
hpp-corbaserver
