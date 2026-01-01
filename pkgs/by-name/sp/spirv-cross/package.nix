{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
<<<<<<< HEAD
  version = "1.4.335.0";
=======
  version = "1.4.328.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "vulkan-sdk-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-BmWHmGh7wu2hkOm04PhHxwTs3e8r8O62tq6SDx6b5xM=";
=======
    hash = "sha256-Fq2Kw8KOlh35hRZy5EnPtWAjazun4vdTk/HyhY76GRM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

<<<<<<< HEAD
  cmakeFlags = lib.optionals stdenv.hostPlatform.isUnix [
=======
  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    (lib.cmakeBool "SPIRV_CROSS_SHARED" true)
  ];

  postFixup = ''
    substituteInPlace $out/lib/pkgconfig/*.pc \
      --replace '=''${prefix}//' '=/'
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Flakebi ];
=======
  meta = with lib; {
    description = "Tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${finalAttrs.version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "spirv-cross";
  };
})
