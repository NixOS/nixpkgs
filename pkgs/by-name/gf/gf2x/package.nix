{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  buildPackages,
  optimize ? false, # impure hardware optimizations
}:
stdenv.mkDerivation rec {
  pname = "gf2x";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "gf2x";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "04g5jg0i4vz46b4w2dvbmahwzi3k6b8g515mfw7im1inc78s14id";
  };

  patches = [
    (fetchpatch {
      name = "gf2x-1.3.0-configure-clang16.patch";
      url = "https://gitlab.inria.fr/gf2x/gf2x/-/commit/a2f0fd388c12ca0b9f4525c6cfbc515418dcbaf8.diff";
      hash = "sha256-Aj2KzWZMR24S04IbPOBPwacCU4rEiB+FFWxtRuF50LA=";
    })
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  # no actual checks present yet (as of 1.2), but can't hurt trying
  # for an indirect test, run ntl's test suite
  doCheck = true;

  configureFlags = lib.optionals (!optimize) [
    "--disable-hardware-specific-code"
  ];

  meta = with lib; {
    description = "Routines for fast arithmetic in GF(2)[x]";
    homepage = "https://gitlab.inria.fr/gf2x/gf2x/";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
