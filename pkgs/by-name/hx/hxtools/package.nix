{
  lib,
  bash,
  fetchurl,
  libHX,
  makeWrapper,
  perl,
  perlPackages,
  stdenv,
  pkg-config,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hxtools";
  version = "20250309";

  src = fetchurl {
    url = "https://inai.de/files/hxtools/hxtools-${finalAttrs.version}.tar.zst";
    hash = "sha256-2ItcEiMe0GzgJ3MxZ28wjmXGSbZtc7BHpkpKIAodAwA=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    zstd
  ];

  buildInputs = [
    # Perl and Bash are pulled to make patchShebangs work.
    perl
    bash
    libHX
  ];

  postInstall = ''
    wrapProgram $out/bin/man2html \
      --prefix PERL5LIB : "${with perlPackages; makePerlPath [ TextCSV_XS ]}"
  '';

  strictDeps = true;

  meta = {
    homepage = "https://inai.de/projects/hxtools/";
    description = "Collection of small tools over the years by j.eng";
    # Taken from https://codeberg.org/jengelh/hxtools/src/branch/master/LICENSES.txt
    license = with lib.licenses; [
      mit
      bsd2Patent
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ meator ];
    platforms = lib.platforms.all;
  };
})
