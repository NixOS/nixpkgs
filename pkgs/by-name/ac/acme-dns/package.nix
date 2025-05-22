{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
}:

buildGoModule rec {
  pname = "acme-dns";
  # Unstable version to allow building with toolchains later than EOL Go 1.22,
  # see https://github.com/joohoi/acme-dns/issues/365
  version = "1.1-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "joohoi";
    repo = "acme-dns";
    rev = "b7a0a8a7bcef39f6158dd596fe716594a170d362";
    hash = "sha256-UApFNcU6a6nzpwbIJv1LLmXVTGLzY0HQBlRATq2s9x8=";
  };

  # Fetching of goModules fails with 'go: updates to go.mod needed'
  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail 'go 1.22' 'go 1.22.0' \
      --replace-fail 'toolchain go1.22.0' 'toolchain go1.24.1'
  '';

  vendorHash = "sha256-pKEOmMF1lvm/CU1n3ykh6YvtRNH/2i+0AvOJzq8eets=";

  postInstall = ''
    install -D -m0444 -t $out/lib/systemd/system ./acme-dns.service
    substituteInPlace $out/lib/systemd/system/acme-dns.service --replace "/usr/local/bin/acme-dns" "$out/bin/acme-dns"
  '';

  passthru.tests = { inherit (nixosTests) acme-dns; };

  meta = {
    description = "Limited DNS server to handle ACME DNS challenges easily and securely";
    homepage = "https://github.com/joohoi/acme-dns";
    changelog = "https://github.com/joohoi/acme-dns/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange ];
    mainProgram = "acme-dns";
    # Tests time out on darwin.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
