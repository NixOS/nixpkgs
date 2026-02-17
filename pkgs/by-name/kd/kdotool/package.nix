{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.2.2-pre";
  pname = "kdotool";

  src = fetchFromGitHub {
    owner = "jinliu";
    repo = "kdotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qx4bWAFQcoLM/r4aNzmoZdjclw8ccAW8lKLda6ON1aQ=";
  };

  patches = [
    # Remove these two on next release.
    (fetchpatch {
      url = "https://github.com/jinliu/kdotool/commit/049e3f5620ad8c5484241d7d06d742bc17d423ed.patch";
      hash = "sha256-VTpHlT6XMVRgJIeLjxZPHkzaYFZCYtS8IAD0mKZ8rzs=";
    })
    (fetchpatch {
      url = "https://github.com/jinliu/kdotool/commit/e0a3bff3b5d9882033dd72836e5fcff572b64135.patch";
      hash = "sha256-6IsV9O2h9N/FxGQRHS8qAbEqdr7282ziGza5K52vpPk=";
    })
  ];

  cargoHash = "sha256-ASR2zMwVCKeEZPYQNoO54J00eZyTn1i6FE0NBCJWSCs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = {
    description = "xdotool clone for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kotatsuyaki ];
  };
})
