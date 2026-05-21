{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  replaceVars,
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
  version = "5.14.44";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    tag = "v${version}";
    hash = "sha256-gG0YkahHP/6KjM+5uzdTRxsonn83cxlJDvdn5HE3h0Q=";
  };

  libcgowm = buildGoModule {
    pname = "nchat-wmchat-libcgowm";
    inherit version src;

    sourceRoot = "${src.name}/lib/wmchat/go";
    vendorHash = "sha256-5Id5+DehV2juLJnEHYvcI67/ykFUQehSrfFW+toZRM0=";

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
stdenv.mkDerivation {
  pname = "nchat";
  inherit version src;

  patches = [
    (replaceVars ./go-libs-build.patch {
      inherit libcgowm;
    })
    # Don't use brew
    ./fix-darwin.patch
  ];

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
