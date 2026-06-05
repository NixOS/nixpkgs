{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  airspy,
  rtl-sdr,
  fdk_aac,
  faad2,
  fftwFloat,
  libsForQt5,
  libsndfile,
  libsamplerate,
  portaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guglielmo";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "marcogrecopriolo";
    repo = "guglielmo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W+KTwtxbTDrtONmkw95gXT28n3k9KS364WOzLLJdGLM=";
  };

  postInstall = ''
    mv $out/linux-bin $out/bin
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    airspy
    rtl-sdr
    fdk_aac
    faad2
    fftwFloat
    libsndfile
    libsamplerate
    portaudio
    libsForQt5.qtmultimedia
    libsForQt5.qwt
  ];

  postFixup = ''
    # guglielmo opens SDR libraries at run time
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        airspy
        rtl-sdr
      ]
    }" $out/bin/.guglielmo-wrapped
  '';

  meta = {
    description = "Qt based FM / Dab tuner";
    mainProgram = "guglielmo";
    homepage = "https://github.com/marcogrecopriolo/guglielmo";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
