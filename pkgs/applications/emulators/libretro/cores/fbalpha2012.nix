{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  runCommand,
  zlib,
}:
mkLibretroCore rec {
  core = "fbalpha2012";
<<<<<<< HEAD
  version = "0-unstable-2025-12-12";
=======
  version = "0-unstable-2024-10-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbalpha2012";
<<<<<<< HEAD
    rev = "c547d8cf3f7748f4094cee658a5d31ec1b79ece4";
    hash = "sha256-owy8IuJ/dAEbUH7hGCR3oLiI4tYuwsNfRYRl6LmyYfc=";
=======
    rev = "77167cea72e808384c136c8c163a6b4975ce7a84";
    hash = "sha256-giEV09dT/e82bmDlRkxpkW04JcsEZc/enIPecqYtg3c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
