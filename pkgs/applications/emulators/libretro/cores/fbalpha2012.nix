{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  runCommand,
  zlib,
}:
mkLibretroCore rec {
  core = "fbalpha2012";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbalpha2012";
    rev = "95fa35582b1ca7ce68de3313615794c8c9d8d7c0";
    hash = "sha256-9F970HETDJsttoQOlqg2dFMzff/drR7G8MxXaSlWTHI=";
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
