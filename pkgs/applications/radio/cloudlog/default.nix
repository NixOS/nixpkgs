{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
, nixosTests
, php
}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudlog";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "magicbug";
    repo = "Cloudlog";
    rev = version;
    hash = "sha256-1V3btXYozgT22KiihZgUiZIktV2Y7IXJgoq7bn16ikk=";
  };

  postPatch = ''
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
    description = "Web based amateur radio logging application built using PHP & MySQL";
    license = licenses.mit;
    homepage = "https://www.magicbug.co.uk/cloudlog";
    platforms = php.meta.platforms;
    maintainers = with maintainers; [ melling ];
  };
}
