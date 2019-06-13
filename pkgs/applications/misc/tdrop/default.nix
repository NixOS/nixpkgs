{ stdenv, lib, fetchFromGitHub, makeWrapper
, xwininfo, xdotool, xprop }:

stdenv.mkDerivation rec {
  pname = "tdrop";
  version = "unstable-2018-11-13";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = "198795c0d2573a31979330d6a2ae946eb81deebf";
    sha256 = "1fhibqgmls64mylcb6q46ipmg1q6pvaqm26vz933gqav6cqsbdzs";
  };

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/tdrop \
      --prefix PATH : ${lib.makeBinPath [ xwininfo xdotool xprop ]}
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "A Glorified WM-Independent Dropdown Creator";
    homepage = https://github.com/noctuid/tdrop;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wedens ];
  };
}
