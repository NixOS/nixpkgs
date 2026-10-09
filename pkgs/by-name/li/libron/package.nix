{
  stdenvNoCC,
  fetchzip,
  installFonts,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libron";
  version = "0.30";

  src = fetchzip {
    url = "https://github.com/nicoverbruggen/libron/releases/download/v${version}/Libron.zip";
    hash = "sha256-xMJYczAUJw/7nX+Hi8YKOyBxOKYrD2YjIQEA+nqb2Io=";
    stripRoot = false;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "A manually tuned font revision of Readerly, optimized for digital reading and e-readers";
    homepage = "https://github.com/nicoverbruggen/libron";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.frakappa ];
    platforms = lib.platforms.all;
  };
}
