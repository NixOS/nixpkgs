{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "dnscrypt-proxy";
  version = "2.1.18";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = finalAttrs.version;
    hash = "sha256-Ol1S2dNVLvXjRbKFf+rlTHtbvybu8fO6DcMoJIgUArY=";
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
      waynr
    ];
    mainProgram = "dnscrypt-proxy";
    platforms = with lib.platforms; unix;
  };
})
