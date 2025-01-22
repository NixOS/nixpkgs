{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "pwalarmctl";
  version = "0.1.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  src = fetchFromGitHub {
    owner = "amyipdev";
    repo = "pwalarmd";
    rev = "v${version}";
    hash = "sha256-xoC1PtDQjkvoWb9x8A43ITo6xyYOv9hxH2pxiZBBvKI=";
  };

  cargoHash = "sha256-OvTGpekiy6j7un+jF4t9tauzi4RndIyPwJRHTOtt4GM=";

  preBuild = ''
    cargo check
  '';

  buildAndTestSubdir = "pwalarmctl";

  meta = {
    description = "Controller for pwalarmd";
    longDescription = ''
      pwalarmctl is a command-line controller for pwalarmd which allows
      for live configuration changes and access to the active state
      of pwalarmd.
    '';
    mainProgram = "pwalarmctl";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ amyipdev ];
  };
}
