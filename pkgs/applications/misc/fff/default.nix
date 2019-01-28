{ stdenv, fetchFromGitHub, makeWrapper, xdg_utils, file, coreutils }:

stdenv.mkDerivation rec {
  pname = "fff";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = pname;
    rev = version;
    sha256 = "1xwvycxyk34c5szhil5d1iby449fdahdgmpibn6raglkbkwfk7a1";
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
