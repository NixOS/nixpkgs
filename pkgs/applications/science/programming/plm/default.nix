{lib, stdenv, fetchurl, makeWrapper, jre, gcc, valgrind}:
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

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre gcc valgrind ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$prefix/bin"

    makeWrapper ${jre}/bin/java $out/bin/plm \
      --add-flags "-jar $src" \
      --prefix PATH : "$PATH"
  '';

  meta = with lib; {
    description = "Free cross-platform programming exerciser";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.all;
    broken = true;
  };
}
