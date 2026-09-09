{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  zlib,
  lzo,
  bzip2,
  lz4,
  nasm,
  perl,
}:

let
  inherit (stdenv.hostPlatform) isx86;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lrzip";
  version = "0.660";

  src = fetchFromGitHub {
    owner = "ckolivas";
    repo = "lrzip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6nNGmruJBim34EqbgJ+hnLTfylEz6t6jLh3O9RcUY34=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
  ]
  ++ lib.optionals isx86 [ nasm ];

  buildInputs = [
    zlib
    lzo
    bzip2
    lz4
  ];

  configureFlags = lib.optionals (!isx86) [
    "--disable-asm"
  ];

  meta = {
    homepage = "http://ck.kolivas.org/apps/lrzip/";
    description = "CK LRZIP compression program (LZMA + RZIP)";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
