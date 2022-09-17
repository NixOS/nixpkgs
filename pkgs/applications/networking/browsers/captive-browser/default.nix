{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "captive-browser";
  version = "2021-08-01";
  goPackagePath = pname;

  src = fetchFromGitHub {
    owner  = "FiloSottile";
    repo   = "captive-browser";
    rev    = "9c707dc32afc6e4146e19b43a3406329c64b6f3c";
    sha256 = "sha256-65lPo5tpE0M/VyyvlzlcVSuHX4AhhVuqK0UF4BIAH/Y=";
  };

  meta = with lib; {
    description = "Dedicated Chrome instance to log into captive portals without messing with DNS settings";
    homepage = "https://blog.filippo.io/captive-browser";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
