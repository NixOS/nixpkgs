{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "apery";
  version = "2.1.0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "HiraokaTakuya";
    # Successor of C++ implementation
    # https://github.com/HiraokaTakuya/apery/blob/d14471fc879062bfabbd181eaa91e90c7cc28a71/Readme.txt#L3-L4
    repo = "apery_rust";
    rev = "8e64bc427bff033a38f1b60b9013ad2d62f88db7";
    hash = "sha256-Y8IBZISutXNgbuc7/qhNoiwYDCP6M9ukhu48t3oZM18=";
    # The submodule includes evaluation files for the installCheckPhase
    fetchSubmodules = true;
  };

  cargoHash = "sha256-xaQ83WKXKSAFRSKzaTFnM2lklGLCJG+i7wa8a+KNR/I=";

  checkFlags = [
    "--skip=movegen"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    usi_command='isready
    go byoyomi 1000
    wait'
    usi_output="$("$out/bin/apery" <<< "$usi_command")"
    [[ "$usi_output" == *'bestmove'* ]]

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    branch = "master";
  };

  meta = {
    description = "USI shogi engine";
    homepage = "https://github.com/HiraokaTakuya/apery_rust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "apery";
  };
}
