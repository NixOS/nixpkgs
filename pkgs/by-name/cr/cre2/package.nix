{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  re2,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cre2";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "marcomaggi";
    repo = "cre2";
    rev = "v${finalAttrs.version}";
    sha256 = "1h9jwn6z8kjf4agla85b5xf7gfkdwncp0mfd8zwk98jkm8y2qx9q";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];
  buildInputs = [
    re2
    texinfo
  ];

  NIX_LDFLAGS = "-lre2 -lpthread";

  configureFlags = [
    "--enable-maintainer-mode"
  ];

  meta = {
    homepage = "http://marcomaggi.github.io/docs/cre2.html";
    description = "C Wrapper for RE2";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
