{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  makeBinaryWrapper,
  fuse3,
}:

buildGoModule (finalAttrs: {
  pname = "plakar";
  version = "1.1.6";

  # to avoid having all the Test(Get|Set|Validate)Service.* tests fail on darwin
  __darwinAllowLocalNetworking = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AnVhWvfE2H5GfsgZyS14nla4vWZy7iIlD3lBP+LAJvA=";
  };

  vendorHash = "sha256-s/4vTHFFfOuGnVc3FK0B5aa9kRATr356/mGydw4cMng=";

  # Remove in next next release
  patches = [
    (fetchpatch {
      name = "backup-allow-multiple-ignore-files.patch";
      url = "https://github.com/PlakarKorp/plakar/commit/049603ba4db8086ceb9aadf6197751083821e699.patch";
      includes = [ "subcommands/backup/backup.go" ];
      hash = "sha256-9uxkXpuWs758xlu3afANB14hqhVut7agvIeOlcm+98k=";
    })
  ];

  # broken test introduce in 1.1.6
  postPatch = ''
    rm login/completion_code_test.go
  '';

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  checkFlags =
    let
      skippedTests = [
        # hangs even outside Nix, so probably an upstream issue:
        "TestRebuildStateVersionMismatch"
        # dry-run fails on any per-file scan error
        "TestBackupDryRunProducesNoSnapshot"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestBTreeScanMemory"
        "TestBTreeScanPebble"
        "TestExecuteCmdServerDefault"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    installManPage $(find $src -regex '.*\.[0-9]$')
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/plakar \
      --suffix PATH : ${lib.makeBinPath [ fuse3 ]}
  '';

  meta = {
    mainProgram = "plakar";
    description = "Encrypted, queryable backups for engineers based on an immutable data store and portable archives";
    homepage = "https://www.plakar.io";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      heph2
      qbit
      nadir-ishiguro
    ];
  };
})
