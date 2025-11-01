{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  oniguruma,
  ffmpeg,
  git,
}:

rustPlatform.buildRustPackage {
  pname = "codemov";
  version = "0-unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codemov";
    rev = "8a4d6e50c21010866ca06f845f30c2aa54c09854";
    hash = "sha256-nOqh8kXS5mx0AM4NvIcwvC0lAZRHsQwrxI0c+9PeroU=";
  };

  cargoHash = "sha256-lelmkdbqKRjSkJIkF5TWJ6LyCTo2j11hZf9QxIPBoOo=";

  cargoPatches = [
    # fix build with rust 1.80 by updating time crate version
    # https://github.com/sloganking/codemov/pull/16
    ./fix-build-with-rust-1.80.patch
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    wrapProgram $out/bin/codemov \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          git
        ]
      }
  '';

  meta = {
    description = "Create a video of how a git repository's code changes over time";
    homepage = "https://github.com/sloganking/codemov";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "codemov";
  };
}
