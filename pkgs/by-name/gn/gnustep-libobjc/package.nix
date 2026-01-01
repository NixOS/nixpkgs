{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  robin-map,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-libobjc";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C7Dwqp5ewtBhuIyfNZmjhGSCBod3xM9KfUXZgHmvIB0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ robin-map ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

<<<<<<< HEAD
  meta = {
    broken = clangStdenv.hostPlatform.isDarwin;
    description = "Objective-C runtime for use with GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    broken = clangStdenv.hostPlatform.isDarwin;
    description = "Objective-C runtime for use with GNUstep";
    homepage = "https://gnustep.github.io/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
