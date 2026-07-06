{
  atool,
  bat,
  catdoc,
  chafa,
  exiftool,
  eza,
  fetchFromGitHub,
  ffmpegthumbnailer,
  file,
  glow,
  gnumeric,
  jq,
  lib,
  libcdio,
  makeWrapper,
  mediainfo,
  odt2txt,
  openssl,
  p7zip,
  poppler-utils,
  stdenv,
  w3m,
}:

stdenv.mkDerivation {
  pname = "fzf-preview";
  version = "0-unstable-2026-02-22";

  src = fetchFromGitHub {
    owner = "niksingh710";
    repo = "fzf-preview";
    rev = "5e5a5a5c4258fa86300cb56224e31416ff7401b5";
    hash = "sha256-ZjBoTsZ2ymfhmUbMpMWT1MB20kLf0BILnCDu75F6WEQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ ./fzf-preview

    wrapProgram $out/bin/fzf-preview \
      --prefix PATH ":" ${
        lib.makeBinPath [
          atool
          bat
          catdoc
          chafa
          exiftool
          eza
          ffmpegthumbnailer
          file
          glow
          gnumeric
          jq
          libcdio
          mediainfo
          odt2txt
          openssl
          p7zip
          poppler-utils
          w3m
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Simple fzf preview script for previewing any filetype in fzf's preview window";

    longDescription = ''
      fzf-preview is a lightweight Bash script designed to enhance the user experience
      with fzf (fuzzy finder) by providing instant previews of files directly in the
      fzf preview pane. It supports a wide variety of filetypes—including images and
      text—and delivers relevant file information in the terminal. The script aims to
      be simple, fast, and highly compatible, making it a useful tool for anyone
      leveraging fzf for file navigation or search.
    '';
    homepage = "https://github.com/niksingh710/fzf-preview";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      niksingh710
    ];
    mainProgram = "fzf-preview";
    platforms = lib.platforms.unix;
  };
}
