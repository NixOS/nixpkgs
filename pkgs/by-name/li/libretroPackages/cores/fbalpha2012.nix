{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  runCommand,
  zlib,
}:
mkLibretroCore rec {
  core = "fbalpha2012";
  version = "0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbalpha2012";
    rev = "0ce31536bef3162fe7e69ff5f555334ec4913cef";
    hash = "sha256-b5pCf5gn/mHoh8+/mIQPxVq1kl5UlDURp4SB5nNsGBI=";
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
