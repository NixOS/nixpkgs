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
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "niksingh710";
    repo = "fzf-preview";
    rev = "5f6e936d1c3943192f9bdade71cff8879bdab3a6";
    hash = "sha256-vDgYv9PjQQYcMKG97ryncd30JPplnEqAKBp5hAE0E+o=";
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
