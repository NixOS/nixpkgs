{
  stdenv,
  fetchurl,
  cmake,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "liborigin";
  version = "3.0.4";

  src = fetchurl {
    url = "https://sourceforge.net/projects/liborigin/files/liborigin/3.0/liborigin-${finalAttrs.version}.tar.gz";
    hash = "sha256-sb819y45iSrTUb7Uo+ckrubPpnMoHeoseMzrkEKnTlc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  patches = [
    ./001-fix-pkg-config-file.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Library for reading OriginLab OPJ project files";
    homepage = "https://sourceforge.net/projects/liborigin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      AhmedAmr
    ];
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
