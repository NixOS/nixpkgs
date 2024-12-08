{
  lib,
  cmake,
  fetchurl,
  stdenv,
  stormlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smpq";
  version = "1.6";

  src = fetchurl {
    url = "https://launchpad.net/smpq/trunk/${finalAttrs.version}/+download/smpq_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-tdLcil3oYptx7l02ErboTYhBi4bFzTm6MV6esEYvGMs=";
  };

  cmakeFlags = [
    (lib.cmakeBool "WITH_KDE" false)
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ stormlib ];

  strictDeps = true;

  meta = {
    homepage = "https://launchpad.net/smpq";
    description = "StormLib MPQ archiving utility";
    license = lib.licenses.gpl3Only;
    mainProgram = "smpq";
    maintainers = with lib.maintainers; [ aanderse karolchmist ];
    platforms = lib.platforms.all;
  };
})
