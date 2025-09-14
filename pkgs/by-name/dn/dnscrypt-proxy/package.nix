{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "dnscrypt-proxy";
  version = "2.1.14";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    hash = "sha256-JPBAlRpJw6Oy4f3twyhX95XqWFtUTEFPjwyVaNMSHmQ=";
  };

  passthru.tests = { inherit (nixosTests) dnscrypt-proxy; };

  meta = {
    description = "Tool that provides secure DNS resolution";

    license = lib.licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with lib.maintainers; [
      atemu
      waynr
    ];
    mainProgram = "dnscrypt-proxy";
    platforms = with lib.platforms; unix;
  };
}
