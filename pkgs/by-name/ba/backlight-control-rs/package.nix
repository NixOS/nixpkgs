{
  rustPlatform,
  fetchFromGitHub,
  coreutils,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "backlight_control_rs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "DOD-101";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yFQASeTmk1a9zmglE7s2Wg3EvNKeQ0qNjWvsCFLYX9U=";
  };

  cargoHash = "sha256-e6gZ8vYNzhqYbeYSS8x4YuTtaDDoZTBtuRtz32HHXS8=";

  postInstall = ''
    substituteInPlace 90-backlight.rules --replace-fail /bin ${coreutils}/bin
    install -Dm644 ./90-backlight.rules -t $out/lib/udev/rules.d
  '';

  meta = {
    description = "Re-written version of backlight_control with a few key improvements";
    homepage = "https://github.com/DOD-101/backlight_control_rs";
    mainProgram = "backlight_control_rs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ dod-101 ];
    platforms = lib.platforms.linux;
  };
}
