{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  catch2_3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autodiff";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "autodiff";
    repo = "autodiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hKIufS5o5tfsbVchwTJxms1n5Im1iTfY3KGWD1s5g9M=";
  };

  # BUILD file exists and darwin can't deal with case insensitive collisions
  preConfigure = ''
    cmakeBuildDir=alt_build
  '';

  nativeBuildInputs = [
    cmake
    eigen
    catch2_3
    python3Packages.pybind11
    python3Packages.distutils
  ];

  postPatch =
    # https://github.com/autodiff/autodiff/pull/391
    ''
      substituteInPlace python/package/CMakeLists.txt \
        --replace-fail PYTHON_EXECUTABLE Python_EXECUTABLE
    '';

  meta = {
    description = "Automatic differentiation made easier for C++";
    homepage = "https://github.com/autodiff/autodiff/tree/main";
    maintainers = [ lib.maintainers.athas ];
    license = lib.licenses.mit;
  };
})
