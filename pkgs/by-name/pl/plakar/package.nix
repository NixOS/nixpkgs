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
  version = "1.1.3";

  # to avoid having all the Test(Get|Set|Validate)Service.* tests fail on darwin
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQyE8VtTdkuevBVMLDfhN1h6/DirdhLgPu+76QfRUas=";
  };

  vendorHash = "sha256-nueFE6Ka1dq4Rt+Qs9YJU9N+yYfEyA8jkVGC4vKLjSI=";

  buildInputs = [
    fuse
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags =
    let
      skippedTests = [
        # hangs even outside Nix, so probably an upstream issue:
        "TestRebuildStateVersionMismatch"
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
      nadir-ishiguro
    ];
  };
})
