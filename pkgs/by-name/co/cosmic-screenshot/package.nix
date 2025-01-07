{
  fetchFromGitHub,
  just,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-+yHpRbK+AWnpcGrC5U0wKbt0u8tm3CFGjKTCDQpb3G0=";
  };

  cargoHash = "sha256-vTHOwnTgMn52AnKivsmzAt7EVp+lFWI7p4AfV2Nac24=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
