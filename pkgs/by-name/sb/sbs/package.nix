{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  imlib2,
  libxinerama,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "onur-ozkan";
    repo = "sbs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Zgu9W/3LwHF/fyaPlxmV/2LdxilO1tU0JY/esLnJVGY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    imlib2
    libx11
    libxinerama
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple background setter with 200 lines of code";
    homepage = "https://github.com/onur-ozkan/sbs";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onur-ozkan ];
    mainProgram = "sbs";
  };
})
