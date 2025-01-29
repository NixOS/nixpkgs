{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  gengetopt,
  help2man,
  groff,
  libharu,
  autoreconfHook,
  pkg-config,
  libpng,
  zlib,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "hyp2mat";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "koendv";
    repo = "hyp2mat";
    rev = "v${version}";
    sha256 = "03ibk51swxfl7pfrhcrfiffdi4mnf8kla0g1xj1lsrvrjwapfx03";
  };

  postPatch = ''
    substituteInPlace doc/Makefile.am --replace-fail \
      '$(HELP2MAN) --output=$@ --no-info --include=$< $(PROGNAME)' \
      '$(HELP2MAN) --output=$@ --no-info --include=$< ${
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          (placeholder "out")
        else
          buildPackages.hyp2mat
      }/bin/`basename $(PROGNAME)`'
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    gengetopt
    groff
    help2man
    pkg-config
  ];

  buildInputs = [
    libharu
    libpng
    zlib
  ];

  configureFlags = [ "--enable-library" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Import Hyperlynx Boardsim files to openEMS, an open source 3D full-wave electromagnetic field solver";
    mainProgram = "hyp2mat";
    homepage = "https://github.com/koendv/hyp2mat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
