{ stdenv, fetchFromGitHub, makeWrapper, bashInteractive, xdg_utils, file, coreutils, w3m, xdotool }:

stdenv.mkDerivation rec {
  pname = "fff";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = pname;
    rev = version;
    sha256 = "14ymdw6l6phnil0xf1frd5kgznaiwppcic0v4hb61s1zpf4wrshg";
  };

  pathAdd = stdenv.lib.makeSearchPath "bin" ([ xdg_utils file coreutils w3m xdotool ]);

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashInteractive ];
  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram "$out/bin/fff" --prefix PATH : $pathAdd
  '';

  meta = with stdenv.lib; {
    description = "Fucking Fast File-Manager";
    homepage = "https://github.com/dylanaraps/fff";
    license = licenses.mit;
    maintainers = [ maintainers.tadeokondrak ];
    platforms = platforms.all;
  };
}
