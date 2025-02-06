{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  faad2,
  taglib,
  fftwFloat,
  libopus,
  opusfile,
  libvorbis,
  libogg,
  chafa,
  miniaudio,
  stb,
}:

stdenv.mkDerivation rec {
  pname = "kew";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "v${version}";
    hash = "sha256-DzJ+7PanA15A9nIbFPWZ/tdxq4aDyParJORcuqHV7jc=";
  };

  patches = [
    ./makefile.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "@miniaudio@" "${miniaudio}"
      substituteInPlace Makefile \
      --replace "@stb@" "${stb}"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib.dev
    faad2
    taglib
    fftwFloat.dev
    libopus
    opusfile
    libvorbis
    libogg
    chafa
    miniaudio
    stb
  ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      demine
      matteopacini
    ];
    mainProgram = "kew";
  };
}
