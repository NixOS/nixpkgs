{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  file, # for libmagic
  ncurses,
  openssl,
  readline,
  sqlite,
  zlib,
  cmake,
  gperf,
  nix-update-script,
  withWhatsApp ? true,
}:

let
  version = "5.11.32";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    tag = "v${version}";
    hash = "sha256-iDy3h1km7Xg6hzkRg3bO8lNSe3CPBk6JOJV8Ph/Rm2w=";
  };

  libcgowm = buildGoModule {
    pname = "nchat-wmchat-libcgowm";
    inherit version src;

    sourceRoot = "${src.name}/lib/wmchat/go";
    vendorHash = "sha256-f6UGMP+IASvII82XZR8GIRG2tEx9ejf6WgCkKnicnD0=";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/
      go build -o $out/ -buildmode=c-archive
      mv $out/go.a $out/libcgowm.a
      ln -s $out/libcgowm.a $out/libref-cgowm.a
      mv $out/go.h $out/libcgowm.h

      runHook postBuild
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "nchat";
  inherit version src;

  nl = "\n";
  postPatch = ''
    substituteInPlace lib/tgchat/ext/td/CMakeLists.txt \
      --replace "get_git_head_revision" "#get_git_head_revision"
    substituteInPlace lib/tgchat/CMakeLists.txt \
      --replace-fail "list(APPEND OPENSSL_ROOT_DIR" "#list(APPEND OPENSSL_ROOT_DIR"

    # specific mangling to handle whatsapp go module:

    substituteInPlace CMakeLists.txt \
      --replace "if(HAS_WHATSAPP AND (NOT GO_VERSION VERSION_GREATER_EQUAL GO_VERSION_MIN))" \
      "if(FALSE AND (NOT GO_VERSION VERSION_GREATER_EQUAL GO_VERSION_MIN))"

    substituteInPlace lib/wmchat/CMakeLists.txt \
      --replace-fail "add_subdirectory(go)" \
    "set(GO_LIBRARIES ${libcgowm}/libcgowm.a)${nl}target_include_directories(wmchat PRIVATE ${libcgowm})"

    substituteInPlace lib/wmchat/CMakeLists.txt \
      --replace-fail "target_link_libraries(wmchat PUBLIC ref-cgowm ncutil \''${GO_LIBRARIES})" \
      "target_link_libraries(wmchat PUBLIC ${libcgowm}/libcgowm.a ncutil \''${GO_LIBRARIES})"

    substituteInPlace lib/wmchat/CMakeLists.txt \
      --replace-fail "add_dependencies(wmchat ref-cgowm)" "#add_dependencies(wmchat ref-cgowm)"
  '';

  nativeBuildInputs = [
    cmake
    gperf
    libcgowm
  ];

  buildInputs = [
    file # for libmagic
    ncurses
    openssl
    readline
    sqlite
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "HAS_WHATSAPP" withWhatsApp)
  ];

  passthru = {
    inherit libcgowm;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "libcgowm"
      ];
    };
  };

  meta = {
    description = "Terminal-based chat client with support for Telegram and WhatsApp";
    changelog = "https://github.com/d99kris/nchat/releases/tag/v${version}";
    homepage = "https://github.com/d99kris/nchat";
    license = lib.licenses.mit;
    mainProgram = "nchat";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sikmir
    ];
    platforms = lib.platforms.unix;
  };
}
