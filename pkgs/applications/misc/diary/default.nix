{ stdenv, fetchFromGitHub, ncurses, readline }:

stdenv.mkDerivation rec {
  version = "0.3";
  name = "diary-${version}";

  src = fetchFromGitHub {
    owner = "in0rdr";
    repo = "diary";
    rev = "v${version}";
    sha256 = "0sda8hrnhs7zvl10iri6srllcimi719yvzn22g9jmiryi9sllay6";
  };

  buildInputs = [ ncurses readline ];

  preInstalledPhase = ''
    mkdir $out/bin -p
    mkdir $out/share/man/ -p
  '';

  installFlags = [ "PREFIX=\${out}" ];

  meta = {
    homepage = "https://github.com/in0rdr/diary";
    description = "Simple CLI diary";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
