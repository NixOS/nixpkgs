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
  inherit (stdenv.hostPlatform) isx86 isDarwin;
  # nasm emits ELF by default and lrzip's build system doesn't pass
  # `-f macho64`, so the resulting `7zCrcOpt_asm.o` is rejected at
  # link time on darwin with "archive member ... is not mach-o".
  # Falling back to the C path via --disable-asm is the simplest fix;
  # the perf delta is negligible for this codepath.
  useAsm = isx86 && !isDarwin;
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
  ++ lib.optionals useAsm [ nasm ];

  buildInputs = [
    zlib
    lzo
    bzip2
    lz4
  ];

  configureFlags = lib.optionals (!useAsm) [
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
