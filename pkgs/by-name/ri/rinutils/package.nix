{
  stdenv,
  lib,
  fetchurl,
  cmake,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rinutils";
  version = "0.10.3";

  src = fetchurl {
    url = "https://github.com/shlomif/rinutils/releases/download/${finalAttrs.version}/rinutils-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-+eUn03psyMe4hwraY8qiTzKrDSn9ERbfPrtoZYMDCVU=";
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  # https://github.com/shlomif/rinutils/issues/5
  # (variable was unused at time of writing)
  postPatch = ''
    substituteInPlace librinutils.pc.in \
      --replace '$'{exec_prefix}/@RINUTILS_INSTALL_MYLIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = {
    description = "C11 / gnu11 utilities C library by Shlomi Fish / Rindolf";
    homepage = "https://github.com/shlomif/rinutils";
    changelog = "https://github.com/shlomif/rinutils/raw/${finalAttrs.version}/NEWS.asciidoc";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
