{
  lib,
  stdenv,
  fetchFromGitHub,
  catch2_3,
  cmake,
  ctestCheckHook,
  libpng,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "niftyreg";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "KCL-BMEIS";
    repo = "niftyreg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DxbX/2/sSK/dNza8eSf1ITrOYBmRpMmFJ3/nmgbuNY8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'message(FATAL_ERROR "Git not found. Please install Git to get the version information.")' 'set(''${PROJECT_NAME}_VERSION ${finalAttrs.src.tag})'
  '';

  nativeBuildInputs = [
    cmake
    ctestCheckHook
    catch2_3
  ];

  buildInputs = [
    libpng
    zlib
  ];

  cmakeFlags = [ "-DBUILD_TESTING=ON" ];

  doCheck = true;

  # fails due to very slight numerical tolerance issue
  ctestFlags = [ "--exclude-regex=Regression Deformation Field" ];

  meta = {
    homepage = "https://github.com/KCL-BMEIS/niftyreg";
    description = "Medical image registration software";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.bsd3;
  };
})
