{
  lib,
  fetchFromGitHub,
  fetchpatch,
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

  meta = {
    description = "xdotool clone for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kotatsuyaki ];
  };
})
