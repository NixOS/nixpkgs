{
  lib,
  flutter329,
  fetchFromGitHub,
  runCommand,
  butterfly,
  yq,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter329.buildFlutterApplication rec {
  pname = "butterfly";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    tag = "v${version}";
    hash = "sha256-ih+oADHEBB8fOt1Uoxc98BNr6BuoONnFNt8wHQxgpfA=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

  gitHashes = {
    dart_leap = "sha256-oO5851cIdrW/asgOePxvwUgjn1XchkH9CKJUruvlLYI=";
    lw_file_system = "sha256-l04sXm9FXHF0ZUdQplnGoih483PczMQvlFF0r/UEuao=";
    networker = "sha256-/3jFIZj66hWbTcIQx9OB5QRrukcBT4zpek+56AVaGIA=";
    lw_file_system_api = "sha256-/Ur9zu4Ovb4x8j1n6Q6FWFuJ9yp92YQG3b7H5CMf3II=";
    lw_sysapi = "sha256-OYVHBiAshYKRH/6BEcY+BXm9VIfSAFnFBOBWlQIO5Tc=";
    material_leap = "sha256-l04sXm9FXHF0ZUdQplnGoih483PczMQvlFF0r/UEuao=";
    networker_crypto = "sha256-nI0luldloScjjix75kR5yOE1ZX8KFxMIC2N4whKlXUg=";
    networker_socket = "sha256-5y1oy0IYDs7nhiIx653vI5Gfh5jrVewkRFxB1mjxlE4=";
    perfect_freehand = "sha256-eBiid097rkF82n65Yg6a4VkKPv+70HIOYJT+9sCD//U=";
    network_info_plus = "sha256-fOh/Qm7T65jDtckMTB3ZP2xT7UH6Wi/x5i61xXNbWac=";
    swamp_api = "sha256-ONaCXeMwEEHDvVmbo3o66O3CTCx4xGR3T5ZtSEwPvaw=";
    reorderable_grid = "sha256-g30DSPL/gsk0r8c2ecoKU4f1P3BF15zLnBVO6RXvDGQ=";
  };

  postInstall = ''
    cp -r linux/debian/usr/share $out/share
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          buildInputs = [ yq ];
          inherit (butterfly) src;
        }
        ''
          cat $src/app/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "butterfly.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Powerful, minimalistic, cross-platform, opensource note-taking app";
    homepage = "https://github.com/LinwoodDev/Butterfly";
    mainProgram = "butterfly";
    license = with lib.licenses; [
      agpl3Plus
      cc-by-sa-40
      asl20
    ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
