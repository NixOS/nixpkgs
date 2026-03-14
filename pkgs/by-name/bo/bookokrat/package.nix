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
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "bugzmanov";
    repo = "bookokrat";
    rev = "v${version}";
    hash = "sha256-oXUJqGHcxZMoJF/OFCMw81AFEK3ACb7xOW4T++GzRHI=";
  };

  cargoHash = "sha256-Wv3Jcrp7iDLdFSVGKtVQCdBLkA7OZjIJxEuc4So+wzA=";

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
    "--skip=test_resolve_library_paths_creates_dirs"
    "--skip=test_resolve_log_path"
    "--skip=test_ctrl_l_force_redraw_svg"
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
