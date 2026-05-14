{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # update depreciated cmake minimum version
    (fetchpatch {
      url = "https://github.com/bombela/backward-cpp/commit/8cb73c397f38b0a375d49335e17980b6c3345ca1.patch?full_index=1";
      hash = "sha256-i+ywKsCdTIS9sqqwAOcf2Mhdz5ReKfThNLHjhvRRQQ0=";
    })
  ];

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
