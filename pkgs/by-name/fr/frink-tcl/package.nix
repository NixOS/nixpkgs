{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frink";
  version = "2.2.2p4";

  src = fetchurl {
    url = "http://catless.ncl.ac.uk/pub/frink-${finalAttrs.version}.tar.gz";
    hash = "sha256-bMqknY/045yN5EZWL9sr3x7BcMABylfidV35qohtc00=";
  };

  postPatch = ''
    substituteInPlace configure --replace '-ansii' '-ansi'
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Tcl source code formatter";
    homepage = "https://catless.ncl.ac.uk/Programs/Frink/";
    platforms = lib.platforms.unix;
    mainProgram = "frink";
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
