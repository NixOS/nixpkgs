{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages,
}:

# redumper is using C++ modules, this requires latest C++20 compiler and build tools
llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "redumper";
<<<<<<< HEAD
  version = "666";
=======
  version = "665";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    tag = "b${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-B5c7ISlQhLBsRYcoCG18uLWkeODJUDGoRAd9n8EejNA=";
=======
    hash = "sha256-eKoQuQD2Z2WzcyZNf/MloEoAH8SlwbKihCPON2Sj1NY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    ninja
    llvmPackages.clang-tools
  ];

  env.NIX_CFLAGS_COMPILE = "-isystem ${llvmPackages.libcxx.dev}/include/c++/v1";

  # https://github.com/superg/redumper/blob/main/.github/workflows/cmake.yml
  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DREDUMPER_VERSION_BUILD=${finalAttrs.version}"
    "-DREDUMPER_CLANG_LINK_OPTIONS=" # overrides the '-static' default
  ];

  meta = {
    homepage = "https://github.com/superg/redumper";
    description = "Low level CD dumper utility";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux;
    mainProgram = "redumper";
  };
})
