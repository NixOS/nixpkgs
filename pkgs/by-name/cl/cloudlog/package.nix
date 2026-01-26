{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  php,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudlog";
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "magicbug";
    repo = "Cloudlog";
    rev = version;
    hash = "sha256-k+/KajRRKsfEFk8ApEJ154pT4cR54ZnavSrk8U4Azso=";
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

  meta = {
    description = "Web based amateur radio logging application built using PHP & MySQL";
    license = lib.licenses.mit;
    homepage = "https://www.magicbug.co.uk/cloudlog";
    platforms = php.meta.platforms;
    maintainers = with lib.maintainers; [ haennetz ];
  };
}
