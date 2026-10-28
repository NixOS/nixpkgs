{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  cmake,
  libxml2,
  meson,
  ninja,
  pkg-config,
  libgudev,
  systemd,
  polkit,
  udevCheckHook,
  libssc,
}:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "3.9";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "iio-sensor-proxy";
    rev = version;
    hash = "sha256-2N/4Fp6QtAhgEzX9cHEDJhFtRsyrtZ80I2jdHdeEmxA=";
  };

  postPatch = ''
    # upstream meson.build currently doesn't have an option to change the default polkit dir
    substituteInPlace data/meson.build \
      --replace 'polkit_policy_directory' "'$out/share/polkit-1/actions'"
  '';

  buildInputs = [
    libgudev
    systemd
    polkit
    libssc
  ];

  nativeBuildInputs = [
    meson
    cmake
    glib
    libxml2
    ninja
    pkg-config
    udevCheckHook
  ];

  mesonFlags = [
    (lib.mesonOption "udevrulesdir" "${placeholder "out"}/lib/udev/rules.d")
    (lib.mesonOption "systemdsystemunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.mesonOption "ssc-support" "enabled")
  ];

  doInstallCheck = true;

  meta = {
    description = "Proxy for sending IIO sensor data to D-Bus";
    mainProgram = "monitor-sensor";
    homepage = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ _999eagle ];
    platforms = lib.platforms.linux;
  };
}
