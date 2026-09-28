{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pugixml,
  rapidjson,
  utf8cpp,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "assimp";
  version = "6.0.5";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWBi1pl5C76UtPhB6SmFipm9oEdnfhELMT3MqfV6oxg=";
  };

  # assimp vendors many libraries that we have available in Nixpkgs, and offers no good way of pulling them from non-vendored sources.
  # We thus patch the CMake declarations to do so.
  # https://github.com/assimp/assimp/issues/5286
  # also see:
  # https://src.fedoraproject.org/rpms/assimp/blob/e0ca8c040bfd661b6d68551b6dc189ba33ffdac1/f/assimp-unbundle.patch
  # https://salsa.debian.org/debian/assimp/-/tree/c60e93150d63590d671d9aab165cf259c71f5df9/debian/patches
  patches = [ ./use-system-libraries.patch ];

  postPatch = ''
    # nix build sandbox does not set /var/tmp up:
    #   https://github.com/assimp/assimp/issues/6270
    substituteInPlace test/unit/UnitTestFileGenerator.h \
      --replace-fail 'define TMP_PATH "/var/tmp/"' 'define TMP_PATH "/tmp/"'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    pugixml
    rapidjson
    utf8cpp
    zlib
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "ASSIMP_BUILD_ASSIMP_TOOLS" true)
    (lib.cmakeBool "ASSIMP_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ASSIMP_WARNINGS_AS_ERRORS" false)
  ];

  # Some matrix tests fail on non-86_64-linux:
  # https://github.com/assimp/assimp/issues/6246
  # https://github.com/assimp/assimp/issues/6247
  # On Darwin, the bundled googletest is not compatible with Clang 21.
  #  contrib/googletest/googletest/include/gtest/gtest-printers.h:498:35:
  #  error: implicit conversion from 'char16_t' to 'char32_t' may change the meaning of the represented code unit
  #  [-Werror,-Wcharacter-conversion]
  doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64;
  checkPhase = ''
    runHook preCheck
    bin/unit
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/assimp/assimp/releases/tag/${finalAttrs.src.tag}";
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
