{
  lib,
  fetchFromGitHub,
  cmake,
  desktopToDarwinBundle,
  pkg-config,
  qt6Packages,
  gnuradioMinimal,
  thrift,
  mpir,
  fftwFloat,
  alsa-lib,
  libjack2,
  wrapGAppsHook3,
  # drivers (optional):
  rtl-sdr,
  hackrf,
  stdenv,
  pulseaudioSupport ? !stdenv.hostPlatform.isDarwin,
  libpulseaudio,
  portaudioSupport ? stdenv.hostPlatform.isDarwin,
  portaudio,
}:

assert pulseaudioSupport -> libpulseaudio != null;
assert portaudioSupport -> portaudio != null;
# audio backends are mutually exclusive
assert !(pulseaudioSupport && portaudioSupport);

gnuradioMinimal.pkgs.mkDerivation rec {
  pname = "gqrx";
  version = "2.17.7";

  src = fetchFromGitHub {
    owner = "gqrx-sdr";
    repo = "gqrx";
    rev = "v${version}";
    hash = "sha256-uvKIxppnNkQge0QE5d1rw0qKo1fT8jwJPTiHilYaT28=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
    wrapGAppsHook3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    gnuradioMinimal.unwrapped.logLib
    mpir
    fftwFloat
    libjack2
    gnuradioMinimal.unwrapped.boost
    qt6Packages.qtbase
    qt6Packages.qtsvg
    gnuradioMinimal.pkgs.osmosdr
    rtl-sdr
    hackrf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    qt6Packages.qtwayland
  ]
  ++ lib.optionals (gnuradioMinimal.hasFeature "gr-ctrlport") [
    thrift
    gnuradioMinimal.unwrapped.python.pkgs.thrift
  ]
  ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
  ++ lib.optionals portaudioSupport [ portaudio ];

  cmakeFlags =
    let
      audioBackend =
        if pulseaudioSupport then
          "Pulseaudio"
        else if portaudioSupport then
          "Portaudio"
        else
          "Gr-audio";
    in
    [
      "-D${if stdenv.hostPlatform.isDarwin then "OSX" else "LINUX"}_AUDIO_BACKEND=${audioBackend}"
    ];

  # Prevent double-wrapping, inject wrapper args manually instead.
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Software defined radio (SDR) receiver";
    mainProgram = "gqrx";
    longDescription = ''
      Gqrx is a software defined radio receiver powered by GNU Radio and the Qt
      GUI toolkit. It can process I/Q data from many types of input devices,
      including Funcube Dongle Pro/Pro+, rtl-sdr, HackRF, and Universal
      Software Radio Peripheral (USRP) devices.
    '';
    homepage = "https://gqrx.dk/";
    # Some of the code comes from the Cutesdr project, with a BSD license, but
    # it's currently unknown which version of the BSD license that is.
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      bjornfor
      fpletz
    ];
  };
}
