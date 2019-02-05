{ stdenv, fetchFromGitHub, makeWrapper, bashInteractive, xdg_utils, file, coreutils, w3m, xdotool }:

stdenv.mkDerivation rec {
  pname = "fff";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = pname;
    rev = version;
    sha256 = "0s5gi5ghwax5gc886pvbpcmsbmzhxzywajwzjsdxwjyd1v1iynwh";
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
    homepage = https://github.com/dylanaraps/fff;
    license = licenses.mit;
    maintainers = [ maintainers.tadeokondrak ];
    platforms = platforms.all;
  };
}
