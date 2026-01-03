{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  autoPatchelfHook,
  stdenv,
  wayland,
  vulkan-loader,
  libxkbcommon,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cantus";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = version;
    hash = "sha256-Mox8OGJFbQd3dy/I1O6OjqDa4FAFcZWiS+zOuTwV6js=";
  };

  cargoHash = "sha256-9+2+PkUA+s6v/Mrpo8M1lLemxClVONbbeHtric2z/Jw=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  runtimeDependencies = [
    libxkbcommon
    vulkan-loader
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    wayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful interactive music widget for Wayland";
    homepage = "https://github.com/CodedNil/cantus";
    license = lib.licenses.mit;
    mainProgram = "cantus";
    maintainers = with lib.maintainers; [ CodedNil ];
    platforms = lib.platforms.linux;
  };
}
