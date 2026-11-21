{
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpz";
  version = "2.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "olegantonyan";
    repo = "mpz";
    tag = finalAttrs.version;
    hash = "sha256-DCA7zMMmcNB10HJdfmn3xHN59yivqUyWAN6cNPuG63Y=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-include xlocale.h";

  meta = {
    description = "Folder player for big local music collections";
    homepage = "https://github.com/olegantonyan/mpz";
    license = lib.licenses.gpl3Only;
    mainProgram = "mpz";
    maintainers = [
      lib.maintainers.burntpineapple12
    ];
  };
})
