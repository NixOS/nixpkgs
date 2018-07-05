{ lib, wrapCommand, fetchurl, jre, gcc, valgrind }:
# gcc and valgrind are not strict dependencies, they could be made
# optional. They are here because plm can only help you learn C if you
# have them installed.

let
  major = "2";
  minor = "5";
  version = "${major}.${minor}";
  jar = fetchurl {
    url = "http://webloria.loria.fr/~quinson/Teaching/PLM/plm-${major}_${minor}.jar";
    sha256 = "0m17cxa3nxi2cbswqvlfzp0mlfi3wrkw8ry2xhkxy6aqzm2mlgcc";
  };
in wrapCommand "plm" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = [ "--add-flags -jar" "--add-flags ${jar}"
                      "--prefix PATH : ${lib.makeBinPath [gcc valgrind]}"];
  meta = with lib; {
    description = "Free cross-platform programming exerciser";
    homepage = http://webloria.loria.fr/~quinson/Teaching/PLM/;
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
