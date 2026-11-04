{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.1.0";
  pname = "htpdate";

  src = fetchFromGitHub {
    owner = "twekkel";
    repo = "htpdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1ycCfWJBZqET1bWKv/ieCAWqD59Hm4hGLuPOgLkD8do=";
  };

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = "https://github.com/twekkel/htpdate";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ julienmalka ];
    mainProgram = "htpdate";
  };
})
