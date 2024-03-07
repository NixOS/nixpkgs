{ lib, stdenv, fetchFromGitHub, installShellFiles, libpulseaudio, nas }:

stdenv.mkDerivation rec {
  pname = "gbsplay";
  version = "0.0.96";

  src = fetchFromGitHub {
    owner = "mmitch";
    repo = "gbsplay";
    rev = version;
    sha256 = "sha256-2sYPP+urcSP67mHzbjRiL9BYgkIpONr7fPPbGQmBOqU=";
  };

  configureFlags = [
    "--without-test" # See mmitch/gbsplay#62
    "--without-contrib"
  ];

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ libpulseaudio nas ];

  postInstall = ''
    installShellCompletion --bash --name gbsplay contrib/gbsplay.bashcompletion
  '';

  meta = with lib; {
    description = "Gameboy sound player";
    license = licenses.gpl1Plus;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
