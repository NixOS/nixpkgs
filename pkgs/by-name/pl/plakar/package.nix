{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse,
}:
buildGoModule (finalAttrs: {
  pname = "plakar";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cuPz0xg/cGKczHLpFqSBfFD7KlygCX6fnfrigv0K2Zs=";
  };

  vendorHash = "sha256-ySzDtj8EdGcWl6H1q44+QR5ebSC76leVygl+c8fa7sk=";

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
