{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse,
}:
buildGoModule (finalAttrs: {
  pname = "plakar";
<<<<<<< HEAD
  version = "1.0.6";
=======
  version = "1.0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-X8m2dXMb+cxWBbKm0MhhY2pNSBTUONyHoPnGlDG9jOg=";
  };

  vendorHash = "sha256-6MdwUJTu9QvqZ3iGEg39L5B5mce7JssFTF3ZmoTuH3M=";
=======
    hash = "sha256-cuPz0xg/cGKczHLpFqSBfFD7KlygCX6fnfrigv0K2Zs=";
  };

  vendorHash = "sha256-ySzDtj8EdGcWl6H1q44+QR5ebSC76leVygl+c8fa7sk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
