{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  stdenv,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shmooz";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "shmooz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U7nF2P1RRmDWk2C0DyXzGh+7TUk0kF3kVXGiKyFLCPA=";
  };

  cargoHash = "sha256-EKrrv89MclJKaX0pVnpmUzMIso3pXyJt4IBJN1muRz0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A zoom / magnifier / screenshot /color picker utility for Wayland compositors written in Rust";
    homepage = "https://github.com/chmouel/shmooz";
    changelog = "https://github.com/chmouel/shmooz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lnk3 ];
    mainProgram = "shmooz";
  };
})
