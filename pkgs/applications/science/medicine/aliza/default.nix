{ stdenv, fetchurl, rpmextract, makeWrapper, patchelf, qt4, zlib, libX11, libXt, libSM, libICE, libXext, libGLU, libGL }:

with stdenv.lib;
stdenv.mkDerivation {
  pname = "aliza";
  version = "1.48.10";
  src = fetchurl {
    # See https://www.aliza-dicom-viewer.com/download
    url = "https://drive.google.com/uc?export=download&id=16WEScARaSrzJpJkyGuOUxDF95eUwGyET";
    sha256 = "1ls16cwd0fmb5axxmy9lgf8cqrf7g7swm26f0gr2vqp4z9bw6qn3";
    name = "aliza.rpm";
  };

  buildInputs = [ rpmextract makeWrapper ];

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
    libs = stdenv.lib.makeLibraryPath [ qt4 zlib stdenv.cc.cc libSM libICE libX11 libXext libXt libGLU libGL ];
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
