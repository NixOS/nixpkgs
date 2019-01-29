{ stdenv, fetchFromGitHub, makeWrapper, xdg_utils, file, coreutils }:

stdenv.mkDerivation rec {
  name = "fff";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = name;
    rev = version;
    sha256 = "0jvv9mwj0qw3rmg1f17wbvx9fl5kxzmkp6j1113l3a6w1na83js0";
  };

  pathAdd = stdenv.lib.makeSearchPath "bin" [ xdg_utils file coreutils ];
  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D fff "$out/bin/fff"
    install -D README.md "$out/share/doc/fff/README.md"
    install -D fff.1 "$out/share/man/man1/fff.1"
    wrapProgram $out/bin/fff --prefix PATH : ${pathAdd}
  '';

  meta = with stdenv.lib; {
    description = "Fucking Fast File-Manager";
    homepage = https://github.com/dylanaraps/fff;
    license = licenses.mit;
    maintainers = [ maintainers.tadeokondrak ];
    platforms = platforms.all;
  };
}
