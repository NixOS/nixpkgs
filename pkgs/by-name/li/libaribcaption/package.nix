{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  fontconfig,
  freetype,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaribcaption";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "xqq";
    repo = "libaribcaption";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y2POfwIcn3Fs3h7aoEYJo6IjRZNKqwDPbV3LHwPdYT8=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    fontconfig
    freetype
  ];

  meta = {
    description = "Portable ARIB STD-B24 Caption Decoder/Renderer";
    homepage = "https://github.com/xqq/libaribcaption";
    changelog = "https://github.com/xqq/libaribcaption/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chayleaf ];
    platforms = lib.platforms.all;
  };
})
