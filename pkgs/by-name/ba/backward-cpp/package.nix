{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "backward";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "bombela";
    repo = "backward-cpp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2k5PjwFxgA/2XPqJrPHxgSInM61FBEcieppBx+MAUKw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Beautiful stack trace pretty printer for C++";
    homepage = "https://github.com/bombela/backward-cpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
