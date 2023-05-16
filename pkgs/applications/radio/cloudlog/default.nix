{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
, nixosTests
<<<<<<< HEAD
, php
}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudlog";
  version = "2.4.8";
=======
, php}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudlog";
  version = "2.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "magicbug";
    repo = "Cloudlog";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-LY8kTZooBzwrrruCjwdiNhxjrmIDV4N2HcfhbSSe6o4=";
=======
    sha256 = "sha256-tFerQJhe/FemtOaP56b2XhLtXH2a8CRT2E69v/77Qz0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPath = ''
    substituteInPlace index.php \
      --replace "define('ENVIRONMENT', 'development');" "define('ENVIRONMENT', 'production');"
  '';

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru = {
    tests = {
      inherit (nixosTests) cloudlog;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
<<<<<<< HEAD
    description = "Web based amateur radio logging application built using PHP & MySQL";
=======
    description = ''
      Web based amateur radio logging application built using PHP & MySQL
      supports general station logging tasks from HF to Microwave with
      supporting applications to support CAT control.
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    homepage = "https://www.magicbug.co.uk/cloudlog";
    platforms = php.meta.platforms;
    maintainers = with maintainers; [ melling ];
  };
}
