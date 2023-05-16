{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-source-clone";
<<<<<<< HEAD
  version = "0.1.4";
=======
  version = "0.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-clone";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-E2pHJO3cdOXmSlTVGsz4tncm9fMaa8Rhsq9YZDNidjs=";
=======
    sha256 = "sha256-cgqv2QdeGz4Aeoy4Dncw03l7NWGsZN1lsrZH7uHxGxw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to clone sources";
    homepage = "https://github.com/exeldro/obs-source-clone";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
