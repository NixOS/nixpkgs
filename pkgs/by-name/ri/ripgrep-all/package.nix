{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  ffmpeg,
  pandoc,
  poppler-utils,
  ripgrep,
  zip,
  fzf,
}:

let
  path = [
    ffmpeg
    pandoc
    poppler-utils
    ripgrep
    zip
    fzf
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "ripgrep-all";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "phiresky";
    repo = "ripgrep-all";
    rev = "v${version}";
    hash = "sha256-fDSetB2UGzth+3KkCKsXUHj3y08RSfQ2nCKDa8OurW4=";
  };

  cargoHash = "sha256-v+lLCI2ti/xL8hcGkm/xDDN9qk0G9MgtijE8xYnhC68=";

  # override debug=true set in Cargo.toml upstream
  RUSTFLAGS = "-C debuginfo=none";

  nativeBuildInputs = [
    makeWrapper
    poppler-utils
  ];

  nativeCheckInputs = path;

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram $bin \
        --prefix PATH ":" "${lib.makeBinPath path}"
    done
  '';

  meta = with lib; {
    changelog = "https://github.com/phiresky/ripgrep-all/blob/${src.rev}/CHANGELOG.md";
    description = "Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more";
    longDescription = ''
      Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.

      rga is a line-oriented search tool that allows you to look for a regex in
      a multitude of file types. rga wraps the awesome ripgrep and enables it
      to search in pdf, docx, sqlite, jpg, movie subtitles (mkv, mp4), etc.
    '';
    homepage = "https://github.com/phiresky/ripgrep-all";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [
      zaninime
      ma27
    ];
    mainProgram = "rga";
  };
}
