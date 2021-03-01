{ stdenv, lib, fetchFromGitHub, makeWrapper
, xwininfo, xdotool, xprop, gawk, coreutils
, gnugrep, procps }:

stdenv.mkDerivation {
  pname = "tdrop";
  version = "unstable-2020-05-14";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = "a9f2862515e5c190ac61d394e7fe7e1039871b89";
    sha256 = "1zxhihgba33k8byjsracsyhby9qpdngbly6c8hpz3pbsyag5liwc";
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
      procps
    ];
  in ''
    wrapProgram $out/bin/tdrop --prefix PATH : ${binPath}
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "A Glorified WM-Independent Dropdown Creator";
    homepage = "https://github.com/noctuid/tdrop";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wedens ];
  };
}
