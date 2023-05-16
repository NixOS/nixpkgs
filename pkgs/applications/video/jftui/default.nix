{ lib, stdenv
, fetchFromGitHub
, pkg-config
, curl
, mpv
, yajl
}:

stdenv.mkDerivation rec {
  pname = "jftui";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-w5DK9B3D3/9VExAQktigVPim33VfpoQPHUZefAS3pWQ=";
=======
    sha256 = "sha256-4j0ypzszNWjHbb4RkMIoqvgz624zoKCKiIpidQUPIF4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    mpv
    yajl
  ];

  installPhase = ''
    install -Dm555 build/jftui $out/bin/jftui
  '';

  meta = with lib; {
    description = "Jellyfin Terminal User Interface ";
    homepage = "https://github.com/Aanok/jftui";
    license = licenses.unlicense;
    maintainers = [ maintainers.nyanloutre ];
    platforms = platforms.linux;
  };
}
