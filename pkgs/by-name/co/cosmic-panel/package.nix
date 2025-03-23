{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-panel";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-nO7Y1SpwvfHhL0OSy7Ti+e8NPzfknW2SGs7IYoF1Jow=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EIp9s42deMaB7BDe7RAqj2+CnTXjHCtZjS5Iq8l46A4=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
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

  meta = {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    mainProgram = "cosmic-panel";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      qyliss
      nyabinary
    ];
    platforms = lib.platforms.linux;
  };
})
