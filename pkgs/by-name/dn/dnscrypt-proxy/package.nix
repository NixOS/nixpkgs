{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "dnscrypt-proxy";
  version = "2.1.21";

  __darwinAllowLocalNetworking = true;

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = finalAttrs.version;
    hash = "sha256-qWedfrfPrI4DTg9x/ZgkX9itlEJEd92nvrgUMRUgXZc=";
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
    # TestUDPListenerReplySource fails on Darwin.
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/DNSCrypt/dnscrypt-proxy/blob/${finalAttrs.version}/ChangeLog";
    description = "Tool that provides secure DNS resolution";
    license = lib.licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with lib.maintainers; [
      atemu
      magicquark
      waynr
    ];
    mainProgram = "dnscrypt-proxy";
    platforms = lib.platforms.unix;
  };
})
