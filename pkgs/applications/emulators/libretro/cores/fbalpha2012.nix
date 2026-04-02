{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  runCommand,
  zlib,
}:
mkLibretroCore rec {
  core = "fbalpha2012";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbalpha2012";
    rev = "15af60bf24e3dc2267a38e3c8532450ebec86317";
    hash = "sha256-7QfDk/j7akaORSekdx96mcDgsFp+kAq1/Cxtu3uPe4A=";
  };

  sourceRoot = "${src.name}/svn-current/trunk";

  # unvendor zlib and broken minizip code
  postPatch =
    let
      minizip-src = runCommand "minizip-src" { } ''
        mkdir $out
        unpackFile ${zlib.src}
        cp */contrib/minizip/{unzip.*,ioapi.*,ints.h,crypt.h} $out/
      '';
    in
    ''
      substituteInPlace ${makefile} \
        --replace-fail '-I$(FBA_LIB_DIR)/zlib' ""

      cp ${minizip-src}/* src/burner
    '';

  buildInputs = [ zlib ];

  makeFlags = [ "EXTERNAL_ZLIB=1" ];

  makefile = "makefile.libretro";

  meta = {
    description = "Port of Final Burn Alpha ~2012 to libretro";
    homepage = "https://github.com/libretro/fbalpha2012";
    license = lib.licenses.unfreeRedistributable;
  };
}
