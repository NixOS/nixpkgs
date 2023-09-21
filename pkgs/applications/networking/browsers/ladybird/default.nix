{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, unzip
, wrapQtAppsHook
, libxcrypt
, qtbase
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "SerenityOS";
    repo = "serenity";
    rev = "45e85d20b64862df119f643f24e2d500c76c58f3";
    hash = "sha256-n2mLg9wNfdMGsJuGj+ukjto9qYjGOIz4cZjgvMGQUrY=";
  };

  sourceRoot = "${finalAttrs.src.name}/Ladybird";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "MACOSX_BUNDLE TRUE" "MACOSX_BUNDLE FALSE"
    # https://github.com/SerenityOS/serenity/issues/17062
    substituteInPlace main.cpp \
      --replace "./SQLServer/SQLServer" "$out/bin/SQLServer"
    # https://github.com/SerenityOS/serenity/issues/10055
    substituteInPlace ../Meta/Lagom/CMakeLists.txt \
      --replace "@rpath" "$out/lib"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    unzip
    wrapQtAppsHook
  ];

  buildInputs = [
    libxcrypt
    qtbase
  ];

  cmakeFlags = [
    # Disable network operations
    "-DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=false"
    "-DENABLE_UNICODE_DATABASE_DOWNLOAD=false"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  # https://github.com/SerenityOS/serenity/issues/10055
  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath $out/lib $out/bin/ladybird
  '';

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  meta = with lib; {
    description = "A browser using the SerenityOS LibWeb engine with a Qt GUI";
    homepage = "https://github.com/awesomekling/ladybird";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.unix;
  };
})
