{
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  ffmpeg,
  rustPlatform,
  glib,
  installShellFiles,
  asciidoc,
}:
rustPlatform.buildRustPackage rec {
  pname = "metadata";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = "metadata";
    rev = "ec9614cfa64ffc95d74e4b19496ebd9b026e692b";
    hash = "sha256-ugirYg3l+zIfKAqp2smLgG99mX9tsy9rmGe6lFAwx5o=";
  };

  cargoHash = "sha256-OMm39sgbq2wTRJTVoCf5imJe3hmf+Djq9w9tzKBrkIM=";

  nativeBuildInputs = [
    pkg-config
    asciidoc
    installShellFiles
    rustPlatform.bindgenHook
  ];

  cargoPatches = [
    (fetchpatch {
      name = "update-crate-ffmpeg-next-version.patch";
      url = "https://github.com/myclevorname/metadata/commit/a1bc9f53d9aa0aeb17cbb530a1da1de4fdf85328.diff";
      hash = "sha256-LEwOK1UFUwLZhqLnoUor5CSOwz4DDjNFMnMOGq1S1Sc=";
    })
  ];

  postBuild = ''
    a2x --doctype manpage --format manpage man/metadata.1.adoc
  '';
  postInstall = ''
    installManPage man/metadata.1
  '';

  buildInputs = [
    ffmpeg
    glib
  ];

  env.FFMPEG_DIR = ffmpeg.dev;

  meta = {
    description = "Media metadata parser and formatter designed for human consumption, powered by FFmpeg";
    maintainers = with lib.maintainers; [ clevor ];
    license = lib.licenses.mit;
    homepage = "https://github.com/zmwangx/metadata";
    mainProgram = "metadata";
  };
}
