{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amoeba-data";
  version = "1.1";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/non-free/a/amoeba-data/amoeba-data_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-b0kwUVC5U1/aygGvpCgD1SLy+i/1c5vkIsEOs0Om7K0=";
  };

  installPhase = ''
    mkdir -p $out/share/amoeba
    cp demo.dat $out/share/amoeba/
  '';

  meta = {
    description = "Fast-paced, polished OpenGL demonstration by Excess (data files)";
    homepage = "https://packages.qa.debian.org/a/amoeba-data.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dezgeg ];
    platforms = lib.platforms.all;
  };
})
