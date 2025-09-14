{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse,
}:
buildGoModule (finalAttrs: {
  pname = "plakar";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4fJB00poA06aQC//zw6L0bRXa8KauFJfZbniCu+vrac=";
  };

  vendorHash = "sha256-UxTETtR7LNOavIS2oJRVKx/Ns2bvzJe+Enh8xFhM2mI=";

  buildInputs = [
    fuse
  ];

  checkFlags =
    let
      skippedTests = [
        # mount: fusermount: exec: "fusermount": executable file not found in $PATH
        "TestExecuteCmdMountDefault"
      ]
      ++ lib.optionals stdenv.isDarwin [
        "TestBTreeScanMemory"
        "TestBTreeScanPebble"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

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
