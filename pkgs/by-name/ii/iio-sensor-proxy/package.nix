{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
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
}:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "3.7";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "iio-sensor-proxy";
    rev = version;
    hash = "sha256-MAfh6bgh39J5J3rlyPjyCkk5KcfWHMZLytZcBRPHaJE=";
  };

  # Fix devices with cros-ec-accel, like Chromebooks and Framework Laptop 12
  # https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/400
  patches = [
    (fetchpatch2 {
      name = "mr400_1.patch";
      url = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/commit/f35d293e65841a3b9c0de778300c7fa58b181fd0.patch";
      hash = "sha256-Gk8Wpy+KFhHAsR3XklcsL3Eo4fHjQuFT6PCN5hz9KHk=";
    })
    (fetchpatch2 {
      name = "mr400_2.patch";
      url = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/commit/7416edf4da98d8e3b75f9eddb7e5c488ac4a4c54.patch";
      hash = "sha256-5UnYam6P+paBHAI0qKXDAvrFM8JYhRVTUFePRTHCp+U=";
    })
    (fetchpatch2 {
      name = "mr400_3.patch";
      url = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/commit/d00109194422a4fe3e9a7bc1235ffc492459c61a.patch";
      hash = "sha256-58KrXbdpR1eWbPmsr8b0ke67hX5J0o0gtqzrz3dc+ck=";
    })
  ];

  postPatch = ''
    # upstream meson.build currently doesn't have an option to change the default polkit dir
    substituteInPlace data/meson.build \
      --replace 'polkit_policy_directory' "'$out/share/polkit-1/actions'"
  '';

  buildInputs = [
    libgudev
    systemd
    polkit
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
