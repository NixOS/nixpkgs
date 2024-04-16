{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schilytools";
  version = "2024-03-21";

  src = fetchurl {
    url = "https://codeberg.org/schilytools/schilytools/releases/download/${finalAttrs.version}/schily-${finalAttrs.version}.tar.bz2";
    hash = "sha256-dtsCLkUMF5GgDml4C1XRii4/w5tf+HCZZDP4cxIDICQ=";
  };

  postPatch = ''
    substituteInPlace RULES/rules.prg \
      --replace-fail "/bin/" ""
  '';

  dontConfigure = true;

  makeFlags = [
    # TODO: Try to unset DESTDIR, according to #65718
    "DESTDIR=${placeholder "out"}"
    "INS_BASE=/"
  ];

  meta = {
    description = "A collection of tools written or formerly managed by Jörg Schilling";
    homepage = "https://codeberg.org/schilytools/schilytools";
    license = with lib.licenses; [
      cddl
      lgpl21Only
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
})
