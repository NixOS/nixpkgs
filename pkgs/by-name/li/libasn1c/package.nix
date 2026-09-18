{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  talloc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libasn1c";
  version = "0.9.39";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libasn1c";
    tag = finalAttrs.version;
    hash = "sha256-+0Mx7LjI82p4/afeUXoC2N82oOJwa8FKJ4E+5U2wJUo=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    talloc
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Runtime library of Lev Walkin's asn1c split out as separate library";
    homepage = "https://github.com/osmocom/libasn1c/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
