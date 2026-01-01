{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-headers";
<<<<<<< HEAD
  version = "1.4.335.0";
=======
  version = "1.4.328.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-HjJjMuqTrYv5LUOWcexzPHb8nhOT4duooDAhDsd44Zo=";
=======
    hash = "sha256-gewCQvcVRw+qdWPWRlYUMTt/aXrZ7Lea058WyqL5c08=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
  meta = {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ralith ];
=======
  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
