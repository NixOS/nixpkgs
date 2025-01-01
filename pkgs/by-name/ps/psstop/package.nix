{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "psstop";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "clearlinux";
    repo = "psstop";
    rev = "v${version}";
    sha256 = "03ir3jjpzm7q8n1qc5jr99hqarr9r529w1zb6f7q4wak2vfj7w9h";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ glib ];

  meta = with lib; {
    homepage = "https://github.com/clearlinux/psstop";
    description = "Show processes' memory usage by looking into pss"; # upstream summary
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "psstop";
  };
}
