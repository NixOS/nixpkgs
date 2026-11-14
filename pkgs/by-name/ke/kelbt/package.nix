{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "kelbt";
  version = "0.16";

  src = fetchurl {
    url = "https://www.colm.net/files/kelbt/kelbt-${version}.tar.gz";
    hash = "sha256-JSVmsXABsIKtA7jrWuDN6UKbZhR4tgXsAYhAy6eixLM=";
  };

  postPatch = ''
    substituteInPlace src/klparse.cpp \
      --replace-fail "char Parser_indicies[]" "signed char Parser_indicies[]"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Backtracking LR parser generator";
    homepage = "https://www.colm.net/open-source/kelbt/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kelbt";
  };
}
