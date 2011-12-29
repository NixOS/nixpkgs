{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "task-warrior-1.9.4";

  src = fetchurl {
    url = http://www.taskwarrior.org/download/task-1.9.4.tar.gz;
    sha256 = "0jnk30k1b2j3nx39il70jmj6p49wxp6cl4awd8hw71gqkcf6480h";
  };

  meta = {
    description = "Command-line todo list manager";
    homepage = http://taskwarrior.org/;
    license = "GPLv2+";
  };
}
