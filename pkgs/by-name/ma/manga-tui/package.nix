{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fetchpatch,
  openssl,
  sqlite,
  stdenv,
  darwin,
  nix-update-script,
}:
let
  version = "0.4.0";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-Se0f5jfYBmvemrYRKduDr1yT3fB2wfQP1fDpa/qrYlI=";
  };

  patches = [
    # apply patches to fix failing tests <https://github.com/josueBarretogit/manga-tui/pull/56>
    (fetchpatch {
      url = "https://github.com/josueBarretogit/manga-tui/commit/131a5208e6a3d74a9ad852baab75334e4a1ebf34.patch";
      hash = "sha256-RIliZcaRVUOb33Cl+uBkMH4b34S1JpvnPGv+QCFQZ58=";
    })
    ./0001-fix-remove-flaky-test.patch
  ];

  cargoHash = "sha256-IufJPCvUEWR5p4PrFlaiQPW9wyIFj/Pd/JHki69L6Es=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  meta = {
    description = "Terminal-based manga reader and downloader with image support";
    homepage = "https://github.com/josueBarretogit/manga-tui";
    changelog = "https://github.com/josueBarretogit/manga-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      isabelroses
      youwen5
    ];
    mainProgram = "manga-tui";
  };

  passthru.updateScript = nix-update-script { };
}
