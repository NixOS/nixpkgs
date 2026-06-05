{
  stdenv,
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
  fuse,
}:
buildGo125Module (finalAttrs: {
  pname = "plakar";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s8YTfTXb49HmfVmJV1EMlSmNmPf78SXIFtAv3sLNoJk=";
  };

  vendorHash = "sha256-JcT5pQnS1GfqX5iNUevmKrviNN34Za82K93561pBDqc=";

  buildInputs = [
    fuse
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags =
    let
      skippedTests = [
        # mount: fusermount: exec: "fusermount": executable file not found in $PATH
        "TestExecuteCmdMountDefault"
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
  '';

  meta = {
    mainProgram = "plakar";
    description = "Encrypted, queryable backups for engineers based on an immutable data store and portable archives";
    homepage = "https://www.plakar.io";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      heph2
      qbit
    ];
  };
})
