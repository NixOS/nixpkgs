{
  stdenv,
  lib,
  fetchFromGitHub,
  scons,
  ragel,
  gengetopt,
  pkg-config,
  libuv,
  openfecSupport ? true,
  openfec,
  speexdsp,
  libunwindSupport ? lib.meta.availableOn stdenv.hostPlatform libunwind,
  libunwind,
  pulseaudioSupport ? true,
  libpulseaudio,
  opensslSupport ? true,
  openssl,
  soxSupport ? true,
  sox,
  libsndfileSupport ? true,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "roc-toolkit";
  version = "0.4.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "roc-streaming";
    repo = "roc-toolkit";
    rev = "v${version}";
    hash = "sha256-53irDq803dTg0YqtC1SOXmYNGypSMAEK+9HJ65pR5PA=";
  };

  nativeBuildInputs = [
    scons
    ragel
    gengetopt
    pkg-config
  ];

  propagatedBuildInputs = [
    libuv
    speexdsp
  ]
  ++ lib.optional openfecSupport openfec
  ++ lib.optional libunwindSupport libunwind
  ++ lib.optional pulseaudioSupport libpulseaudio
  ++ lib.optional opensslSupport openssl
  ++ lib.optional soxSupport sox
  ++ lib.optional libsndfileSupport libsndfile;

  sconsFlags =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      "--build=${stdenv.buildPlatform.config}"
      "--host=${stdenv.hostPlatform.config}"
    ]
    ++ [ "--prefix=${placeholder "out"}" ]
    ++ lib.optional (!opensslSupport) "--disable-openssl"
    ++ lib.optional (!soxSupport) "--disable-sox"
    ++ lib.optional (!libunwindSupport) "--disable-libunwind"
    ++ lib.optional (!pulseaudioSupport) "--disable-pulseaudio"
    ++ lib.optional (!libsndfileSupport) "--disable-sndfile"
    ++ lib.optional stdenv.hostPlatform.isFreeBSD "--platform=unix"
    ++ (
      if (!openfecSupport) then
        [ "--disable-openfec" ]
      else
        [
          "--with-libraries=${openfec}/lib"
          "--with-openfec-includes=${openfec.dev}/include"
        ]
    );

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    NIX_CFLAGS_COMPILE = "-D_XOPEN_SOURCE=700 -D__BSD_VISIBLE";
    NIX_LDFLAGS = "-lpthread";
  };

  meta = with lib; {
    description = "Roc is a toolkit for real-time audio streaming over the network";
    homepage = "https://github.com/roc-streaming/roc-toolkit";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
