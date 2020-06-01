{stdenv, fetchurl, makeWrapper, jre8, gcc, valgrind}:
# gcc and valgrind are not strict dependencies, they could be made
# optional. They are here because plm can only help you learn C if you
# have them installed.
stdenv.mkDerivation rec {
  major = "2";
  minor = "5";
  version = "${major}-${minor}";
  pname = "plm";

  src = fetchurl {
    url = "http://webloria.loria.fr/~quinson/Teaching/PLM/plm-${major}_${minor}.jar";
    sha256 = "0m17cxa3nxi2cbswqvlfzp0mlfi3wrkw8ry2xhkxy6aqzm2mlgcc";
    name = "${pname}-${version}.jar";
  };

  buildInputs = [ makeWrapper jre8 gcc valgrind ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$prefix/bin"

    makeWrapper ${jre8}/bin/java $out/bin/plm \
      --add-flags "-jar $src" \
      --prefix PATH : "$PATH"
  '';

  meta = with stdenv.lib; {
    description = "Free cross-platform programming exerciser";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
    broken = true;
  };
}
