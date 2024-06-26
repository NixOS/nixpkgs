{
  stdenv,
  lib,
  fetchFromGitHub,
  git,
  linux-pam,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "v${version}";
    hash = "sha256-78XD6DK9aQi8hITWJWnFZ3U9zWTcuw3vtRiU3Lhu7O4=";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "all" ];
  nativeBuildInputs = [ git ];
  buildInputs = [
    libxcb
    linux-pam
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/fairyglade/ly";
    maintainers = [ maintainers.vidister ];
    platforms = platforms.linux;
    mainProgram = "ly";
  };
}
