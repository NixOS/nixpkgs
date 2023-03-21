{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
, nixosTests
, php}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudlog";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "magicbug";
    repo = "Cloudlog";
    rev = version;
    sha256 = "sha256-aF1f6EmlcUgZOkHJgrW6P923QW56vWMH8CZ4cnYiiSk=";
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
