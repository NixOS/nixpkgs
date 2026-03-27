{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bsc";
  version = "3.3.12";

  src = fetchFromGitHub {
    owner = "IlyaGrebnov";
    repo = "libbsc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3dFwmThnDzbXB6m/rDfbSz4DZAlIsm4gUOT7YwexpKA=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "check_c_compiler_flag(-march=native COMPILER_SUPPORTS_MARCH_NATIVE_C)" "" \
      --replace-fail "check_cxx_compiler_flag(-march=native COMPILER_SUPPORTS_MARCH_NATIVE_CXX)" ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance block-sorting data compression library";
    homepage = "http://libbsc.com/";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "bsc";
  };
})
