{
  fetchFromGitHub,
  just,
  lib,
  libcosmicAppHook,
  rustPlatform,
  stdenv,
  util-linux,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-vFYt9Jn61p74jcNzExYOsZHxh9T+0QG7b0yHiAnF4HY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3a/KNMoG7Be/6kcwi9Xp3G3xTf5IbGuZCPkSgQYqqRc=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    util-linux
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-panel";

    maintainers = with maintainers; [
      nyabinary
      qyliss
      thefossguy
    ];
  };
}
