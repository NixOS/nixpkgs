{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catimg";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "posva";
    repo = "catimg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TkUrDVg/EJQ3cAWosRDJ09pmOB0NANW7c/MFyH//Iok=";
  };

  nativeBuildInputs = [ cmake ];

  env = lib.optionalAttrs (stdenv.hostPlatform.libc == "glibc") {
    CFLAGS = "-D_DEFAULT_SOURCE";
  };

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/posva/catimg";
    description = "Insanely fast image printing in your terminal";
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = lib.platforms.unix;
    mainProgram = "catimg";
  };

})
