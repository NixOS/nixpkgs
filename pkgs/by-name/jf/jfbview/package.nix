{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  freetype,
  harfbuzz,
  imlib2,
  libjpeg,
  ncurses,
  openjpeg,
  zlib,
  xorg,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jfbview";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jichu4n";
    repo = "jfbview";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-ASgKXk5iVqKsBc1uzakHs5ojUb6AptGm9LxNyFcDngc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    freetype
    harfbuzz
    imlib2
    libjpeg
    ncurses
    openjpeg
    xorg.libX11
    zlib
  ];

  env.LDFLAGS = "-lImlib2";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "/") # relative to $out
  ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PDF and image viewer for the Linux framebuffer";
    homepage = "https://github.com/jichu4n/jfbview";
    changelog = "https://github.com/jichu4n/jfbview/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "jfbview";
  };
})
