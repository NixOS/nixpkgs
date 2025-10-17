{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libX11,
  glfw,
  glew,
  fftwFloat,
  volk,
  zstd,

  # Sources
  airspy_source ? true,
  airspy,
  airspyhf_source ? true,
  airspyhf,
  audio_source ? true,
  bladerf_source ? stdenv.hostPlatform.isLinux,
  libbladeRF,
  file_source ? true,
  hackrf_source ? true,
  hackrf,
  hermes_source ? true,
  limesdr_source ? true,
  limesuite,
  network_source ? true,
  # needs libperseus-sdr, not yet available in nixpks
  perseus_source ? false,
  plutosdr_source ? stdenv.hostPlatform.isLinux,
  libiio,
  libad9361,
  rfspace_source ? true,
  rtl_sdr_source ? true,
  rtl-sdr-osmocom,
  libusb1,
  # osmocom better w/ rtlsdr v4
  rtl_tcp_source ? true,
  sdrplay_source ? false,
  sdrplay,
  sdrpp_server_source ? true,
  soapy_source ? true,
  soapysdr-with-plugins,
  spectran_http_source ? true,
  spyserver_source ? true,
  usrp_source ? false,
  uhd,
  boost,

  # Sinks
  audio_sink ? true,
  rtaudio,
  network_sink ? true,
  portaudio_sink ? false,
  portaudio,

  # Decoders
  atv_decoder ? true,
  dab_decoder ? false,
  falcon9_decoder ? false,
  kg_sstv_decoder ? false,
  m17_decoder ? false,
  codec2,
  meteor_demodulator ? true,
  pager_decoder ? true,
  radio ? true,
  vor_receiver ? false,
  weather_sat_decoder ? false,

  # Misc
  discord_presence ? true,
  frequency_manager ? true,
  iq_exporter ? true,
  recorder ? true,
  rigctl_client ? true,
  rigctl_server ? true,
  scanner ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdrpp";

  upstreamVersion = "1.2.1";
  version = "${finalAttrs.upstreamVersion}-unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "AlexandreRouma";
    repo = "SDRPlusPlus";
    rev = "4658a1ade6707dee6f2ae09ba9eb71097223ea93";
    hash = "sha256-UxYAcqOMPQYdUbL2636LpOGbCaxHjLiJhsH62s+0AZU=";
  };

  patches = [
    ./0001-Allow-management-of-resources-and-modules-paths.patch
    # CMake 4 dropped support of versions lower than 3.5,
    # versions lower than 3.10 are deprecated.
    ./cmake4.patch
  ];

  postPatch = ''
    substituteInPlace decoder_modules/m17_decoder/src/m17dsp.h \
      --replace-fail "codec2.h" "codec2/codec2.h"

    substituteInPlace core/src/version.h \
      --replace-fail "${finalAttrs.upstreamVersion}" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glfw
    glew
    fftwFloat
    volk
    zstd
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libX11
  ++ lib.optional airspy_source airspy
  ++ lib.optional airspyhf_source airspyhf
  ++ lib.optional bladerf_source libbladeRF
  ++ lib.optional hackrf_source hackrf
  ++ lib.optional limesdr_source limesuite
  ++ lib.optionals rtl_sdr_source [
    rtl-sdr-osmocom
    libusb1
  ]
  ++ lib.optional sdrplay_source sdrplay
  ++ lib.optional soapy_source soapysdr-with-plugins
  ++ lib.optionals plutosdr_source [
    libiio
    libad9361
  ]
  ++ lib.optionals usrp_source [
    uhd
    boost
  ]
  ++ lib.optional (audio_source || audio_sink) rtaudio
  ++ lib.optional portaudio_sink portaudio
  ++ lib.optional (dab_decoder || m17_decoder) codec2;

  cmakeFlags = [
    # Sources
    (lib.cmakeBool "OPT_BUILD_AIRSPYHF_SOURCE" airspyhf_source)
    (lib.cmakeBool "OPT_BUILD_AIRSPY_SOURCE" airspy_source)
    (lib.cmakeBool "OPT_BUILD_AUDIO_SOURCE" audio_source)
    (lib.cmakeBool "OPT_BUILD_BLADERF_SOURCE" bladerf_source)
    (lib.cmakeBool "OPT_BUILD_FILE_SOURCE" file_source)
    (lib.cmakeBool "OPT_BUILD_HACKRF_SOURCE" hackrf_source)
    (lib.cmakeBool "OPT_BUILD_HERMES_SOURCE" hermes_source)
    (lib.cmakeBool "OPT_BUILD_LIMESDR_SOURCE" limesdr_source)
    (lib.cmakeBool "OPT_BUILD_NETWORK_SOURCE" network_source)
    (lib.cmakeBool "OPT_BUILD_PERSEUS_SOURCE" perseus_source)
    (lib.cmakeBool "OPT_BUILD_PLUTOSDR_SOURCE" plutosdr_source)
    (lib.cmakeBool "OPT_BUILD_RFSPACE_SOURCE" rfspace_source)
    (lib.cmakeBool "OPT_BUILD_RTL_SDR_SOURCE" rtl_sdr_source)
    (lib.cmakeBool "OPT_BUILD_RTL_TCP_SOURCE" rtl_tcp_source)
    (lib.cmakeBool "OPT_BUILD_SDRPLAY_SOURCE" sdrplay_source)
    (lib.cmakeBool "OPT_BUILD_SDRPP_SERVER_SOURCE" sdrpp_server_source)
    (lib.cmakeBool "OPT_BUILD_SOAPY_SOURCE" soapy_source)
    (lib.cmakeBool "OPT_BUILD_SPECTRAN_HTTP_SOURCE" spectran_http_source)
    (lib.cmakeBool "OPT_BUILD_SPYSERVER_SOURCE" spyserver_source)
    (lib.cmakeBool "OPT_BUILD_USRP_SOURCE" usrp_source)

    # Sinks
    (lib.cmakeBool "OPT_BUILD_AUDIO_SINK" audio_sink)
    (lib.cmakeBool "OPT_BUILD_NETWORK_SINK" network_sink)
    (lib.cmakeBool "OPT_BUILD_NEW_PORTAUDIO_SINK" portaudio_sink)

    # Decoders
    (lib.cmakeBool "OPT_BUILD_ATV_DECODER" atv_decoder)
    (lib.cmakeBool "OPT_BUILD_DAB_DECODER" dab_decoder)
    (lib.cmakeBool "OPT_BUILD_FALCON9_DECODER" falcon9_decoder)
    (lib.cmakeBool "OPT_BUILD_KG_SSTV_DECODER" kg_sstv_decoder)
    (lib.cmakeBool "OPT_BUILD_M17_DECODER" m17_decoder)
    (lib.cmakeBool "OPT_BUILD_METEOR_DEMODULATOR" meteor_demodulator)
    (lib.cmakeBool "OPT_BUILD_PAGER_DECODER" pager_decoder)
    (lib.cmakeBool "OPT_BUILD_RADIO" radio)
    (lib.cmakeBool "OPT_BUILD_VOR_RECEIVER" vor_receiver)
    (lib.cmakeBool "OPT_BUILD_WEATHER_SAT_DECODER" weather_sat_decoder)

    # Misc
    (lib.cmakeBool "OPT_BUILD_DISCORD_PRESENCE" discord_presence)
    (lib.cmakeBool "OPT_BUILD_FREQUENCY_MANAGER" frequency_manager)
    (lib.cmakeBool "OPT_BUILD_IQ_EXPORTER" iq_exporter)
    (lib.cmakeBool "OPT_BUILD_RECORDER" recorder)
    (lib.cmakeBool "OPT_BUILD_RIGCTL_CLIENT" rigctl_client)
    (lib.cmakeBool "OPT_BUILD_RIGCTL_SERVER" rigctl_server)
    (lib.cmakeBool "OPT_BUILD_SCANNER" scanner)
  ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  meta = with lib; {
    description = "Cross-Platform SDR Software";
    homepage = "https://github.com/AlexandreRouma/SDRPlusPlus";
    license = licenses.gpl3Only;
    # The DAB decoder is broken upstream. See: https://github.com/AlexandreRouma/SDRPlusPlus/issues/1511
    broken = dab_decoder;
    maintainers = with maintainers; [
      sikmir
      zaninime
    ];
    mainProgram = "sdrpp";
  };
})
