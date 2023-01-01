{ lib
, stdenvNoCC
, fetchFromGitHub
, nixosTests
, php}:

stdenvNoCC.mkDerivation rec {
  name = "cloudlog";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "magicbug";
    repo = "Cloudlog";
    rev = version;
    sha256 = "sha256-IepCeV/mYy/GEzRTXf67LYQQaN5Rj5Z77KaF2l30r60=";
  };

  postPath = ''
    substituteInPlace index.php \
      --replace "define('ENVIRONMENT', 'development');" "define('ENVIRONMENT', 'production');"
  '';

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru.tests = {
    inherit (nixosTests) cloudlog;
  };

  meta = with lib; {
    description = ''
      Web based amateur radio logging application built using PHP & MySQL
      supports general station logging tasks from HF to Microwave with
      supporting applications to support CAT control.
    '';
    license = licenses.mit;
    homepage = "https://www.magicbug.co.uk/cloudlog";
    platforms = php.meta.platforms;
    maintainers = with maintainers; [ melling ];
  };
}
