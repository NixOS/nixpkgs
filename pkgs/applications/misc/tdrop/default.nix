{ stdenv, lib, fetchFromGitHub, makeWrapper
, xwininfo, xdotool, xprop, gawk, coreutils
, gnugrep, procps-ng }:

stdenv.mkDerivation rec {
  pname = "tdrop";
  version = "unstable-2019-10-04";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = "60435d240f47719a69ab1f7b2be68ca3ef1df1df";
    sha256 = "1krry5p17hzp0lpilylch8v1f485kgxkx4lmwpghzj4vpgvwk8k4";
  };

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = let
    binPath = lib.makeBinPath [
      xwininfo
      xdotool
      xprop
      gawk
      coreutils
      gnugrep
      procps-ng
    ];
  in ''
    wrapProgram $out/bin/tdrop --prefix PATH : ${binPath}
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
