{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  sphinx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dex";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = "dex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1fgSz4f6W+Dr3mo4vQY8buD2dNC8RBMGrwCTOIzH7rQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ sphinx ];
  buildInputs = [ python3 ];
  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
  ];

  meta = {
    description = "Program to generate and execute DesktopEntry files of the Application type";
    homepage = "https://github.com/jceb/dex";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "dex";
  };
})
