{ stdenv, fetchFromGitHub, makeWrapper, xdg_utils, file, coreutils }:

stdenv.mkDerivation rec {
  pname = "fff";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = pname;
    rev = version;
    sha256 = "0pqxqg1gnl3kgqma5vb0wcy4n9xbm0dp7g7dxl60cwcyqvd4vm3i";
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
