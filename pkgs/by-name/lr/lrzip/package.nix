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
stdenv.mkDerivation rec {
  pname = "lrzip";
  version = "0.651";

  src = fetchFromGitHub {
    owner = "ckolivas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mb324ojtLV0S10KhL7Vjf3DhSOtCy1pFMTzvLkTnpXM=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Building the ASM/x86 directory creates an empty archive,
    # which fails on darwin, so remove it
    # https://github.com/ckolivas/lrzip/issues/193
    # https://github.com/Homebrew/homebrew-core/pull/85360
    substituteInPlace lzma/Makefile.am --replace "SUBDIRS = C ASM/x86" "SUBDIRS = C"
    substituteInPlace configure.ac --replace "-f elf64" "-f macho64"
  '';

  nativeBuildInputs = [
    autoreconfHook
    perl
  ] ++ lib.optionals isx86 [ nasm ];

  buildInputs = [
    zlib
    lzo
    bzip2
    lz4
  ];

  configureFlags = lib.optionals (!isx86) [
    "--disable-asm"
  ];

  meta = with lib; {
    homepage = "http://ck.kolivas.org/apps/lrzip/";
    description = "CK LRZIP compression program (LZMA + RZIP)";
    maintainers = [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
