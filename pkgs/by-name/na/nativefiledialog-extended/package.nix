{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_ttf,
  gtk3,
  testers,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nativefiledialog-extended";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "btzy";
    repo = "nativefiledialog-extended";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GwT42lMZAAKSJpUJE6MYOpSLKUD5o9nSe9lcsoeXgJY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "nfd_ROOT_PROJECT" true)
    (lib.cmakeBool "NFD_BUILD_TESTS" true)
    (lib.cmakeBool "NFD_BUILD_SDL2_TESTS" true)
    (lib.cmakeBool "NFD_INSTALL" true)
  ];

  # NOTE: Although the tests have been compiled, they still require GUI
  # interactions. Let's disable running them for now.
  doCheck = false;

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "nfd" ];
    };
  };

  meta = {
    homepage = "https://github.com/btzy/nativefiledialog-extended";
    description = "Cross platform native file dialog library with C and C++ bindings";
    longDescription = ''
      A small C library with that portably invokes native file open, folder
      select and file save dialogs. Write dialog code once and have it pop up
      native dialogs on all supported platforms. Avoid linking large
      dependencies like wxWidgets and Qt.
    '';
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ yzx9 ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
