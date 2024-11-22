{ lib, stdenv, fetchFromGitHub, makeWrapper, bashInteractive, xdg-utils, file, coreutils, w3m, xdotool }:

stdenv.mkDerivation rec {
  pname = "fff";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = pname;
    rev = version;
    sha256 = "14ymdw6l6phnil0xf1frd5kgznaiwppcic0v4hb61s1zpf4wrshg";
  };

  pathAdd = lib.makeSearchPath "bin" ([ xdg-utils file coreutils w3m xdotool ]);

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashInteractive ];
  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram "$out/bin/fff" --prefix PATH : $pathAdd
  '';

  meta = with lib; {
    description = "Fucking Fast File-Manager";
    mainProgram = "fff";
    homepage = "https://github.com/dylanaraps/fff";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
