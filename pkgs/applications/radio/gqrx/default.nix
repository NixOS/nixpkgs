{ lib
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qtsvg
, qtwayland
, gnuradioMinimal
, thrift
, mpir
, fftwFloat
, alsa-lib
, libjack2
, wrapGAppsHook
, wrapQtAppsHook
# drivers (optional):
, rtl-sdr
, hackrf
, pulseaudioSupport ? true, libpulseaudio
, portaudioSupport ? false, portaudio
}:

assert pulseaudioSupport -> libpulseaudio != null;
assert portaudioSupport -> portaudio != null;
# audio backends are mutually exclusive
assert !(pulseaudioSupport && portaudioSupport);

gnuradioMinimal.pkgs.mkDerivation rec {
  pname = "gqrx";
  version = "2.17.3";

  src = fetchFromGitHub {
    owner = "gqrx-sdr";
    repo = "gqrx";
    rev = "v${version}";
    hash = "sha256-dHbDy/aIsqBQG1raeN9nM/QtiFgy+Qhoj/ThN8LV6gI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook
  ];
  buildInputs = [
    gnuradioMinimal.unwrapped.logLib
    mpir
    fftwFloat
    alsa-lib
    libjack2
    gnuradioMinimal.unwrapped.boost
    qtbase
    qtsvg
    qtwayland
    gnuradioMinimal.pkgs.osmosdr
    rtl-sdr
    hackrf
  ] ++ lib.optionals (gnuradioMinimal.hasFeature "gr-ctrlport") [
    thrift
    gnuradioMinimal.unwrapped.python.pkgs.thrift
  ] ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ lib.optionals portaudioSupport [ portaudio ];

  cmakeFlags =
    let
      audioBackend =
        if pulseaudioSupport
        then "Pulseaudio"
        else if portaudioSupport
        then "Portaudio"
        else "Gr-audio";
    in [
      "-DLINUX_AUDIO_BACKEND=${audioBackend}"
    ];

   # Prevent double-wrapping, inject wrapper args manually instead.
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Software defined radio (SDR) receiver";
    longDescription = ''
      Gqrx is a software defined radio receiver powered by GNU Radio and the Qt
      GUI toolkit. It can process I/Q data from many types of input devices,
      including Funcube Dongle Pro/Pro+, rtl-sdr, HackRF, and Universal
      Software Radio Peripheral (USRP) devices.
    '';
    homepage = "https://gqrx.dk/";
    # Some of the code comes from the Cutesdr project, with a BSD license, but
    # it's currently unknown which version of the BSD license that is.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;  # should work on Darwin / macOS too
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
