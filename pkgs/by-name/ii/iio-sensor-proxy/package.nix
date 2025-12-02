{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
  libqmi,
}:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "3.8";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "iio-sensor-proxy";
    rev = version;
    hash = "sha256-ZVaV4Aj4alr5eP3uz6SunpeRsMOo8YcZMqCcB0DUYGY=";
  };

  postPatch = ''
    # upstream meson.build currently doesn't have an option to change the default polkit dir
    substituteInPlace data/meson.build \
      --replace 'polkit_policy_directory' "'$out/share/polkit-1/actions'"
  '';

  patches = [
    # https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/381
    (fetchpatch {
      url = "https://gitlab.postmarketos.org/postmarketOS/pmaports/-/raw/af17d8f3a7572ed2be40d5a28c6ce08c74bd36c7/temp/iio-sensor-proxy/0001-iio-sensor-proxy-depend-on-libssc.patch";
      hash = "sha256-faOpfR6qit68R2b+sk9/k4XeA6Ao5UuerrfFzMaD3MM=";
    })
  ];

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
    (lib.mesonBool "ssc-support" true)
  ];

  doInstallCheck = true;

  meta = with lib; {
    description = "Proxy for sending IIO sensor data to D-Bus";
    mainProgram = "monitor-sensor";
    homepage = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _999eagle ];
    platforms = platforms.linux;
  };
}
