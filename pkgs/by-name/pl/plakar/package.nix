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
  version = "1.1.4";

  # to avoid having all the Test(Get|Set|Validate)Service.* tests fail on darwin
  __darwinAllowLocalNetworking = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Urj1BG3XGhSroaa9pl9NGiKj38J1P+H9sA7noGwIhdc=";
  };

  vendorHash = "sha256-6Y9wzK0NMG/iJMR0eQFu20x4hKidJjwFv3Yx+BVNMTg=";

  # Remove in next release
  patches = [
    (fetchpatch {
      name = "fuse3-support.patch";
      url = "https://github.com/PlakarKorp/plakar/commit/d21d74b653a84806af79129a634b97596cbb00d8.patch";
      includes = [ "go.mod" ];
      hash = "sha256-K/Y7DrJJsQaQpQiEpU9OnY8JOMVXnu79L4Qaxsi2xlc=";
    })
  ];

  # Remove in next release
  postPatch = ''
    substituteInPlace go.sum \
      --replace-fail \
        "github.com/anacrolix/fuse v0.3.2 h1:ablJbmHt2BeYGnNrlfXkAcKN96mMMeXZN/ZAqo1AY/o=" \
        "github.com/anacrolix/fuse v0.3.3-0.20260723023734-9e1272bc0085 h1:9cQ6o8Qv3jbLAJ0a8dQX8ZntDtWY2ESuI3DtqhqWxEs=" \
      --replace-fail \
        "github.com/anacrolix/fuse v0.3.2/go.mod h1:vN3X/6E+uHNjg5F8Oy9FD9I+pYxeDWeB8mNjIoxL5ds=" \
        "github.com/anacrolix/fuse v0.3.3-0.20260723023734-9e1272bc0085/go.mod h1:V14Hqx/K8kb3e6beqqT6reYy25RPP+2Ps3c0vEXoNMA="
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
