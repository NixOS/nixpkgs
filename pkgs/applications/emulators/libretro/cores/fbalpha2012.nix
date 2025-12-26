{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  runCommand,
  zlib,
}:
mkLibretroCore rec {
  core = "fbalpha2012";
  version = "0-unstable-2025-12-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbalpha2012";
    rev = "c547d8cf3f7748f4094cee658a5d31ec1b79ece4";
    hash = "sha256-owy8IuJ/dAEbUH7hGCR3oLiI4tYuwsNfRYRl6LmyYfc=";
  };

  sourceRoot = "${src.name}/svn-current/trunk";

  # unvendor zlib and broken minizip code
  postPatch =
    let
      minizip-src = runCommand "minizip-src" { } ''
        mkdir $out
        unpackFile ${zlib.src}
        cp */contrib/minizip/{unzip.*,ioapi.*,crypt.h} $out/
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
