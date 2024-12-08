{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "pwalarmd";
  version = "0.1.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  src = fetchFromGitHub {
    owner = "amyipdev";
    repo = "pwalarmd";
    rev = "v${version}";
    hash = "sha256-xoC1PtDQjkvoWb9x8A43ITo6xyYOv9hxH2pxiZBBvKI=";
  };

  cargoHash = "sha256-cRAFnmgvzWLFAjB7H1rU4FdxMwm0J6d76kdFPoXpPMw=";

  meta = {
    description = "Background CLI-based alarm system for *nix";
    longDescription = ''
      pwalarmd is a command-line (daemon-based) alarm system.
      It has extensive configuration and personalization, PulseAudio
      and PipeWire support, and supports live configuration changes.
    '';
    mainProgram = "pwalarmd";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ amyipdev ];
  };
}
