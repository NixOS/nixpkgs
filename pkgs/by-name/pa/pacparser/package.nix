{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacparser";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "manugarg";
    repo = "pacparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X842+xPjM404aQJTc2JwqU4vq8kgyKhpnqVu70pNLks=";
  };

  patches = [
    # jsapi.c:96:35: error: passing argument 5 of 'TryArgumentFormatter' from incompatible pointer type []
    #   96 | #define JS_ADDRESSOF_VA_LIST(ap) (&(ap))
    # suggested by https://github.com/manugarg/pacparser/issues/194#issuecomment-2262030966
    ./fix-invalid-pointer-type.patch
  ];

  makeFlags = [
    "NO_INTERNET=1"
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Library to parse proxy auto-config (PAC) files";
    homepage = "https://pacparser.manugarg.com/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "pactester";
  };
})
