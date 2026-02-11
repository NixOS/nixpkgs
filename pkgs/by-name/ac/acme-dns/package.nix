{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "acme-dns";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "acme-dns";
    repo = "acme-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tjVI+CaQTN1SB/RkTg0CJ1o9azb2ULwR1uKK5fJZ8fw=";
  };

  vendorHash = "sha256-n3icQQkdA0nCkvthsFsUTrYg0B3t8hROL4QXgBQRbSg=";

  postInstall = ''
    install -D -m0444 -t $out/lib/systemd/system ./acme-dns.service
    substituteInPlace $out/lib/systemd/system/acme-dns.service --replace "/usr/local/bin/acme-dns" "$out/bin/acme-dns"
  '';

  passthru.tests = { inherit (nixosTests) acme-dns; };

  meta = {
    description = "Limited DNS server to handle ACME DNS challenges easily and securely";
    homepage = "https://github.com/acme-dns/acme-dns";
    changelog = "https://github.com/acme-dns/acme-dns/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange ];
    mainProgram = "acme-dns";
    # Tests time out on darwin.
    broken = stdenv.hostPlatform.isDarwin;
  };
})
