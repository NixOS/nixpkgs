{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librtprocess";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "CarVac";
    repo = "librtprocess";
    rev = finalAttrs.version;
    hash = "sha256-/1o6SWUor+ZBQ6RsK2PoDRu03jcVRG58PNYFttriH2w=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  meta = {
    description = "Highly optimized library for processing RAW images";
    homepage = "https://github.com/CarVac/librtprocess";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      returntoreality
    ];
    platforms = lib.platforms.unix;
  };
})
