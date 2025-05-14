{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "dnscrypt-proxy";
  version = "2.1.8";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "sha256-/D5RE8AbI9i9TVdFQCYW8OLPU4TgIIDRsZfWEyXo92g=";
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
