{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "re-flex";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+wQyNmHfWQxO58q0M7hrW2xp8i6xrwb8oHAjfZLiI28=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://www.genivia.com/doc/reflex/html";
    description = "Regex-centric, fast lexical analyzer generator for C++ with full Unicode support";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ prrlvr ];
    mainProgram = "reflex";
  };
})
