{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
}:

buildGo127Module (finalAttrs: {
  pname = "dnscrypt-proxy";
  version = "2.1.19";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = finalAttrs.version;
    hash = "sha256-HKrsdhB9FSBGXvKQcf7IeI2SBKCUXodcWyteivlySDM=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/dnscrypt-proxy/-/raw/main/0001-Make-configuration-file-hierarchy-compliant.patch";
      hash = "sha256-DDHDEd812ko7qYgu0zTn4toek9KZRVQEarxZIe1Mrcg=";
    })
  ];

  postInstall = ''
    mkdir -p $out/etc/dnscrypt-proxy
    cp dnscrypt-proxy/example-dnscrypt-proxy.toml $out/etc/dnscrypt-proxy/dnscrypt-proxy.toml
  '';

  passthru.tests = { inherit (nixosTests) dnscrypt-proxy; };

  meta = {
    description = "Tool that provides secure DNS resolution";

    license = lib.licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with lib.maintainers; [
      atemu
      magicquark
      waynr
    ];
    mainProgram = "dnscrypt-proxy";
    platforms = with lib.platforms; unix;
  };
})
