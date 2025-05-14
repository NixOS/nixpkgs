{
  config,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  useGTK ? config.libiodbc.gtk or false,
}:

stdenv.mkDerivation rec {
  pname = "libiodbc";
  version = "3.52.16";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/${pname}-${version}.tar.gz";
    sha256 = "sha256-OJizLQeWE2D28s822zYDa3GaIw5HZGklioDzIkPoRfo=";
  };

  configureFlags = [
    "--disable-libodbc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals useGTK [ gtk2 ];

  preBuild = ''
    export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
  '';

  meta = with lib; {
    description = "iODBC driver manager";
    homepage = "https://www.iodbc.org";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
