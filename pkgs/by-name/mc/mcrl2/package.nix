{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGLU,
  libGL,
  qt6,
  boost,
}:

stdenv.mkDerivation rec {
  version = "202407";
  build_nr = "1";
  pname = "mcrl2";

  src = fetchurl {
    url = "https://www.mcrl2.org/download/release/mcrl2-${version}.${build_nr}.tar.gz";
    hash = "sha256-VhP9BFSujxYMcQVu6P6k6yiH2UUhCB3P+Pj+9Ir7x6s=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGLU
    libGL
    qt6.qtbase
    boost
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Toolset for model-checking concurrent systems and protocols";
    longDescription = ''
      A formal specification language with an associated toolset,
      that can be used for modelling, validation and verification of
      concurrent systems and protocols
    '';
    homepage = "https://www.mcrl2.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ moretea ];
    platforms = platforms.unix;
  };
}
