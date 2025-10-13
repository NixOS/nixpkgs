{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse,
}:
buildGoModule (finalAttrs: {
  pname = "plakar";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gClQiXZEPui7g3Ps6yhB2tN36PnkqADo9iD4Gm6DpD4=";
  };

  vendorHash = "sha256-JVk8wiuuicwWgEbqIjp7ryC4k3uc4DiXnJ5FxYbXV5M=";

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
