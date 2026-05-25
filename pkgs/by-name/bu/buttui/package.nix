{
  fetchFromGitea,
  rustPlatform,
  lib,
  stdenv,
  cargo,
  pkg-config,
  dbus,
  udev,
  alsa-lib,
  pipewire,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buttui";
  version = "a498bc38d581613ef07df74c255ba12f256c014f";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "derZonk";
    repo = "buttui";
    rev = finalAttrs.version;
    hash = "sha256-092+a/1O3xF1cgH7/p1oeFPw0ENWxqANd+F/Z+wfh40=";
  };

  buildInputs = [
    dbus
    udev
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
    alsa-lib
    pipewire
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    pipewire
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  PKG_CONFIG_PATH = "${dbus.dev}/lib/pkgconfig:";

  cargoHash = "sha256-gMbGVQ7GxfHxLB5/TwxIjCeaQHmreTfFwFht5Sfo1UY=";

  meta = {
    description = "Terminal UI for buttplug.io compatible devices";
    homepage = "https://buttui.de/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.luNeder ];
    inherit (cargo.meta) platforms;
    mainProgram = "buttui";
  };
})
