{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sheenbidi";
  version = "3.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Tehreer";
    repo = "SheenBidi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e/24MlRX+93b34qD2V1+2XVhMh4WEy2qvt9Rgvybwxs=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace sheenbidi.pc.in \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@'
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  meta = {
    description = "Implementation of Unicode Bidirectional Algorithm";
    longDescription = ''
      SheenBidi provides a complete implementation of Unicode Bidirectional
      Algorithm, useful for rendering text in right-to-left scripts like Arabic
      and Hebrew alongside left-to-right text.
    '';
    homepage = "https://github.com/Tehreer/SheenBidi";
    changelog = "https://github.com/Tehreer/SheenBidi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
