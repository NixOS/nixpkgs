{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  lib,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "asmjit";
<<<<<<< HEAD
  version = "0-unstable-2025-12-13";
=======
  version = "0-unstable-2025-02-12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
<<<<<<< HEAD
    rev = "c87860217e43e2a06060fcaae5b468f6a55b9963";
    hash = "sha256-9JSAONQe5cS/dP5GLd5TJroOPPeI7IEmt/8WDq6MP2k=";
=======
    rev = "029075b84bf0161a761beb63e6eda519a29020db";
    hash = "sha256-/9F1rFNPwJUrVOVeK9sIA+Q7UrqQpQy8T6g4ywcoJc8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  strictDeps = true;

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Machine code generation for C++";
    longDescription = ''
      AsmJit is a lightweight library for machine code generation written in
      C++ language. It can generate machine code for X86, X86_64, and AArch64
      architectures and supports baseline instructions and all recent
      extensions.
    '';
    homepage = "https://asmjit.com/";
<<<<<<< HEAD
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ thillux ];
=======
    license = licenses.zlib;
    maintainers = with maintainers; [ thillux ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
