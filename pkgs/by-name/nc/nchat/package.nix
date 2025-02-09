{
  lib,
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
  stdenv,
  darwin,
}:

let
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    tag = "v${version}";
    hash = "sha256-NrAU47GA7ZASJ7vCo1S8nyGBpfsZn4EBBqx2c4HKx7k=";
  };

  libcgowm = buildGoModule {
    pname = "nchat-wmchat-libcgowm";
    inherit version src;

    sourceRoot = "${src.name}/lib/wmchat/go";
    vendorHash = "sha256-EdbOO5cCDT1CcPlCBgMoPDg65FcoOYvBwZa4bz0hfGE=";

    buildPhase = ''
      mkdir -p $out/
      go build -o $out/ -buildmode=c-archive
      mv $out/go.a $out/libcgowm.a
      ln -s $out/libcgowm.a $out/libref-cgowm.a
      mv $out/go.h $out/libcgowm.h
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

  buildInputs =
    [
      file # for libmagic
      ncurses
      openssl
      readline
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        Cocoa
        Foundation
      ]
    );

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

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
