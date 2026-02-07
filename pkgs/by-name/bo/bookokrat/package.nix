{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  mupdf,
  freetype,
  fontconfig,
  harfbuzz,
  openjpeg,
  jbig2dec,
  gumbo,
  python3,
  unzip,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "bookokrat";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "bugzmanov";
    repo = "bookokrat";
    rev = "dc876b5749c5a45d1184eac2d7e5048788761bf1";
    hash = "sha256-mYWKqaPZejUaAX3IBUeL3tWWJYU5xrIND7JDRuWoM14=";
  };

  cargoHash = "sha256-nwKioyjsHnUkEK06TGSHfH+7Z8Xl2fu1YqyizIKHJIo=";

  nativeBuildInputs = [
    pkg-config
    python3
    rustPlatform.bindgenHook
    unzip
  ];

  buildInputs = [
    mupdf
    freetype
    harfbuzz
    fontconfig
    openjpeg
    jbig2dec
    gumbo
    zlib
  ];

  checkFlags = [
    # Can't test in sandbox environment
    "--skip=test_definition_list_with_complex_content_svg"
    "--skip=test_mouse_scroll_file_list_svg"
    "--skip=test_toc_chapter_navigation_svg"
  ];

  meta = {
    description = "A terminal-based EPUB/PDF Books reader";
    homepage = "https://bugzmanov.github.io/bookokrat/";
    changelog = "https://github.com/bugzmanov/bookokrat/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ruiiiijiiiiang ];
    mainProgram = "bookokrat";
  };
}
