{ lib, stdenv, fetchurl, rpmextract, makeWrapper, patchelf, qt4, zlib, libX11, libXt, libSM, libICE, libXext, libGLU, libGL }:

with lib;
stdenv.mkDerivation {
  pname = "aliza";
  version = "1.98.43";
  src = fetchurl {
    # See https://www.aliza-dicom-viewer.com/download
    url = "https://drive.google.com/uc?export=download&id=1HiDYUVN30oSWZWt3HBp7gNRBCLLtJM1I";
    sha256 = "0d70q67j2q0wdn4m2fxljqb97jwmscqgg3rm1rkb77fi2ik206ra";
    name = "aliza.rpm";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ rpmextract ];

  unpackCmd = "rpmextract $curSrc";

  patchPhase = ''
    sed -i 's/^Exec.*$/Exec=aliza %F/' share/applications/aliza.desktop
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin share $out

    runHook postInstall
  '';

  postInstall = let
    libs = lib.makeLibraryPath [ qt4 zlib stdenv.cc.cc libSM libICE libX11 libXext libXt libGLU libGL ];
  in ''
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/aliza

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/aliza-vtkvol

    wrapProgram $out/bin/aliza \
      --prefix LD_LIBRARY_PATH : ${libs}

    wrapProgram $out/bin/aliza-vtkvol \
      --prefix LD_LIBRARY_PATH : ${libs}
  '';

  meta = {
    description = "Medical imaging software with 2D, 3D and 4D capabilities";
    homepage = "https://www.aliza-dicom-viewer.com";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mounium ];
    platforms = platforms.linux;
  };
}
