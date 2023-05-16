{ lib
, stdenv
, fetchFromGitHub
, python3
, which
, ldc
, zlib
, lz4
}:

stdenv.mkDerivation rec {
  pname = "sambamba";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3O9bHGpMuCgdR2Wm7Dv1VUjMT1QTn8K1hdwgjvwhFDw=";
=======
    sha256 = "sha256-HwAzsbT71Q35Io6H7Hzs4RTatpRpdHqV0cwPYAlsf6c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ which python3 ldc ];
  buildInputs = [ zlib lz4 ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  # Upstream's install target is broken; copy manually
  installPhase = ''
    runHook preInstall

    install -Dm755 bin/sambamba-${version} $out/bin/sambamba

    runHook postInstall
  '';

  meta = with lib; {
    description = "SAM/BAM processing tool";
    homepage = "https://lomereiter.github.io/sambamba/";
    maintainers = with maintainers; [ jbedo ];
    license = with licenses; gpl2;
    platforms = platforms.x86_64;
  };
}
