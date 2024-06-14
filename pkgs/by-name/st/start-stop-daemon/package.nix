{ lib
, stdenv
, fetchFromGitHub
, gnumake
}:

stdenv.mkDerivation rec {
  pname = "start-stop-daemon";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "zeppe-lin";
    repo = "start-stop-daemon";
    rev = "v${version}";
    hash = "sha256-zeem291FACUxX5eodwXi/Z3xG0NHQDNWCIKiD25NfKc=";
  };

  preConfigure = ''
    substituteInPlace config.mk \
      --replace "/usr/local" "$out"
  '';

  meta = with lib; {
    description = "Start and stop daemon programs";
    homepage = "https://github.com/zeppe-lin/start-stop-daemon";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ supercoolspy ];
    mainProgram = "start-stop-daemon";
  };
}
