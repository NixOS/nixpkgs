{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,

  # tests
  scion,
  openssl,
}:

buildGoModule (finalAttrs: {
  pname = "scion-bootstrapper";
  version = "0.0.8-unstable-2024-11-28";

  src = fetchFromGitHub {
    owner = "netsec-ethz";
    repo = "bootstrapper";
    rev = "3fc6dad144843b3e7724e1b7e0af63235936168e";
    hash = "sha256-rs8BVN+jqwpSIfdtUzi9X9zSRStHJZSWjr32m8vWQ8g=";
  };

  vendorHash = "sha256-SITnZXQ76eVedNVYWVwtH1ezDoMBmE1Uh9FpHA5+T8c=";

  patches = [
    # https://github.com/netsec-ethz/bootstrapper/pull/31
    ./0001-Update-to-Go-1.24.patch
  ];

  nativeCheckInputs = [
    scion
    openssl
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # non-reproducible since it depends on the cert time
        "TestVerify"
        # requires internet access
        "TestDNSLookupAkaNS"
        "TestDNSLookupExternalIP"
        "TestReverseLookupDomains"
        "TestReverseLookupWHOIS"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mv $out/bin/bootstrapper $out/bin/scion-bootstrapper
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Bootstrapper for SCION network configuration";
    homepage = "https://github.com/netsec-ethz/bootstrapper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      matthewcroughan
      sarcasticadmin
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "scion-bootstrapper";
  };
})
