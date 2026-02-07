{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simpleproxy";
  version = "3.5";
  rev = "v.${finalAttrs.version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "vzaliva";
    repo = "simpleproxy";
    sha256 = "1my9g4vp19dikx3fsbii4ichid1bs9b9in46bkg05gbljhj340f6";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/vzaliva/simpleproxy";
    description = "Simple TCP proxy";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.montag451 ];
    mainProgram = "simpleproxy";
  };
})
