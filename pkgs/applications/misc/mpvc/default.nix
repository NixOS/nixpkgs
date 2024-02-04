{ lib, stdenv, socat, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mpvc";
  version = "1.5-test";

  src = fetchFromGitHub {
    owner = "lwilletts";
    repo = "mpvc";
    rev = version;
    sha256 = "sha256-kodHy9DV/bih3Fpy0H64m30/+TdvQ26cxyWJizG1cL0=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/mpvc --prefix PATH : "${socat}/bin/"
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ socat ];

  meta = with lib; {
    description = "A mpc-like control interface for mpv";
    homepage = "https://github.com/lwilletts/mpvc";
    license = licenses.mit;
    maintainers = [ maintainers.neeasade ];
    platforms = platforms.linux;
  };
}
