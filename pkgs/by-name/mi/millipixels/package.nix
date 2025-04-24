{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  glib,
  meson,
  ninja,
  pkg-config,
  rustc,
  libbsd,
  libcamera,
  gtk3,
  libtiff,
  zbar,
  libjpeg,
  libexif,
  libraw,
  libpulseaudio,
  ffmpeg-headless,
  v4l-utils,
  makeWrapper,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "millipixels";
  version = "0.22.0";

  src = fetchFromGitLab {
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    domain = "source.puri.sm";
    hash = "sha256-pRREQRYyD9+dpRvcfsNiNthFy08Yeup9xDn+x+RWDrE=";
  };
  patches = [
    # fix for https://source.puri.sm/Librem5/millipixels/-/issues/87, can be removed with the next release (if there ever will be one)
    (fetchpatch {
      url = "https://source.puri.sm/Librem5/millipixels/-/commit/5a0776993051a0af54c148702f36dbbf1064b917.patch?merge_request_iid=105";
      hash = "sha256-OdjTFHMx64eb94/kSCaxeM/Ju/JxOPoorw2ogwTPP3s=";
    })
  ];

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    rustc
    makeWrapper
  ];

  buildInputs = [
    libbsd
    libcamera
    gtk3
    libtiff
    zbar
    libpulseaudio
    libraw
    libexif
    libjpeg
    python3
  ];

  postInstall = ''
    wrapProgram $out/bin/millipixels \
      --prefix PATH : ${
        lib.makeBinPath [
          v4l-utils
          ffmpeg-headless
        ]
      }
  '';

  meta = with lib; {
    description = "Camera application for the Librem 5";
    homepage = "https://source.puri.sm/Librem5/millipixels";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ _999eagle ];
    platforms = platforms.linux;
  };
}
