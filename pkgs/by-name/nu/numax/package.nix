{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  pkg-config,
  openssl,
  stdenv,
  apple-sdk,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "numax";
  version = "0.1.0-alpha.3";

  src = fetchFromGitHub {
    owner = "GianIac";
    repo = "numax";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IAWvAJg7vPfhSyi9+IIHZrD5EKcUBacwsoUNbfbiLPk=";
  };

  cargoHash = "sha256-CBinlXuk0HgsFyXMp2Gr8VsMiQ7MlyWa49cPEXegoMc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    apple-sdk
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "A distributed CLI and sync runner utility";
    downloadPage = "https://github.com/GianIac/numax";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.guelakais ];
    mainProgram = "nx";
    platforms = lib.platforms.linux ++ lib.platforms.windows ++ lib.platforms.darwin;
  };
})
