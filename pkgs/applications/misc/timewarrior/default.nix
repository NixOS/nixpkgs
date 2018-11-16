{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "timewarrior-${version}";
  version = "1.1.1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://taskwarrior.org/download/timew-${version}.tar.gz";
    sha256 = "1jfcfzdwk5qqhxznj1bgy0sx3lnp3z5lqr9kch9a7iazwmi9lz8z";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A command-line time tracker";
    homepage = https://taskwarrior.org/docs/timewarrior;
    license = licenses.mit;
    maintainers = with maintainers; [ mrVanDalo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

