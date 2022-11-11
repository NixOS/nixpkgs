{ lib, stdenv, fetchurl, rpmextract, makeWrapper, patchelf, qt4, zlib, libX11, libXt, libSM, libICE, libXext, libGLU, libGL }:

with lib;
stdenv.mkDerivation {
  pname = "aliza";
  version = "1.98.57";
  src = fetchurl {
    # See https://www.aliza-dicom-viewer.com/download
    urls = [
      "https://drive.google.com/uc?export=download&id=1-AXa3tjy_onecW2k7ftjAQl0KGTb0B1Y"
      "https://web.archive.org/web/20210327224315/https://doc-0s-0s-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/1lgjid9ti29rdf5ebmd7o58iqhs3gfpo/1616884950000/16072287944266838401/*/1-AXa3tjy_onecW2k7ftjAQl0KGTb0B1Y?e=download"
    ];
    sha256 = "01qk2gadmc24pmfdnmpiz7vgfiqkvhznyq9rsr153frscg76gc9b";
    name = "aliza.rpm";
  };

  nativeBuildInputs = [ makeWrapper rpmextract ];

  unpackCmd = "rpmextract $curSrc";

  postPatch = ''
    sed -i 's/^Exec.*$/Exec=aliza %F/' share/applications/aliza.desktop
  '';

  installPhase = ''
    runHook preInstall

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
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mounium ];
    platforms = platforms.linux;
  };
}
