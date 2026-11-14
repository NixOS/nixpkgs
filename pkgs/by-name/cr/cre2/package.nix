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
    hash = "sha256-OHUsPKpTojT5R81VcJnlbbp3XC+rIEWfIk5O9I3lMsE=";
  };

  patches = [
    ./missing-header-include-pr-34.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];
  buildInputs = [
    re2
    texinfo
  ];

  env.NIX_LDFLAGS = toString [
    "-lre2"
    "-lpthread"
  ];

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
