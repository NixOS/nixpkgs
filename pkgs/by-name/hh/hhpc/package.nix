{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "hhpc";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "aktau";
    repo = "hhpc";
    rev = "v${version}";
    sha256 = "1djsw1r38mh6zx0rbyn2cfa931hyddib4fl3i27c4z7xinl709ss";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libx11 ];

  installPhase = ''
    mkdir -p $out/bin
    cp hhpc $out/bin/
  '';

  meta = {
    description = "Hides the mouse pointer in X11";
    maintainers = with lib.maintainers; [ nico202 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    mainProgram = "hhpc";
  };
}
