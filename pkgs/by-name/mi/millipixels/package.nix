{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
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
  version = "0.23.0";

  src = fetchFromGitLab {
    owner = "Librem5";
    repo = "millipixels";
    rev = "v${version}";
    domain = "source.puri.sm";
    hash = "sha256-Sj14t6LeZWNONcgrwJxN4J1/85m1SLgmmcRnHQUULHI=";
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Camera application for the Librem 5";
    homepage = "https://source.puri.sm/Librem5/millipixels";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ _999eagle ];
    platforms = platforms.linux;
  };
}
