{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.3.0";
  pname = "kdotool";

  src = fetchFromGitHub {
    owner = "jinliu";
    repo = "kdotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PQAw7I0Lpi0+JMNZGlmyDDkelkSYUX/sZVEh3PjR8VM=";
  };

  cargoHash = "sha256-11V+J8/LlHGdA/FSc7aD9IeVBIFwYM0LXXiFtc/FuLY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "xdotool clone for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    changelog = "https://github.com/jinliu/kdotool/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kotatsuyaki ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux;
    mainProgram = "kdotool";
  };
})
