{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  robin-map,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-libobjc";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+NP214bbisk7dCFAHaxnhNOfC/0bZLp8Dd2A9F2vK+s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ robin-map ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    broken = clangStdenv.hostPlatform.isDarwin;
    description = "Objective-C runtime for use with GNUstep";
    homepage = "https://gnustep.github.io/";
    license = licenses.mit;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
    platforms = platforms.unix;
  };
})
