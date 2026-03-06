{
  lib,
  stdenv,
  fetchurl,
  ladspaH,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmt";
  version = "1.18";

  src = fetchurl {
    url = "http://www.ladspa.org/download/cmt_${finalAttrs.version}.tgz";
    sha256 = "sha256-qC+GNt4fSto4ahmaAXqc13Wkm0nnFrEejdP3I8k99so=";
  };

  buildInputs = [ ladspaH ];

  preBuild = ''
    cd src
  '';

  installFlags = [ "INSTALL_PLUGINS_DIR=${placeholder "out"}/lib/ladspa" ];
  preInstall = ''
    mkdir -p $out/lib/ladspa
  '';

  meta = {
    description = "Computer Music Toolkit";
    homepage = "https://www.ladspa.org/cmt";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sjfloat ];
  };
})
