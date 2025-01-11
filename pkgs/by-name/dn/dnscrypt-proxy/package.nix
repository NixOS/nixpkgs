{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "dnscrypt-proxy";
  version = "2.1.6";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "sha256-PtZHtUq384KsATcMfTW11erlZVBm/qs7RpwsplIzOus=";
  };

  passthru.tests = { inherit (nixosTests) dnscrypt-proxy2; };

  meta = with lib; {
    description = "Tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with maintainers; [
      atemu
      waynr
    ];
    mainProgram = "dnscrypt-proxy";
    platforms = with platforms; unix;
  };
}
