{ stdenv, lib, fetchzip, patchelf, freeglut, libXmu, libXi, libX11, libICE, libGLU_combined, libSM, libXext, dialog, makeWrapper }:
let
  lpath = stdenv.lib.makeLibraryPath [ libXmu libXi libX11 freeglut libICE libGLU_combined libSM libXext ];
in
stdenv.mkDerivation rec {
  name = "iceSL-${version}";
  version = "2.1.10";

  src =  if stdenv.system == "x86_64-linux" then fetchzip {
    url = "https://gforge.inria.fr/frs/download.php/file/37268/icesl${version}-amd64.zip";
    sha256 = "0dv3mq6wy46xk9blzzmgbdxpsjdaxid3zadfrysxlhmgl7zb2cn2";
  } else if stdenv.system == "i686-linux" then fetchzip {
    url = "https://gforge.inria.fr/frs/download.php/file/37267/icesl${version}-i386.zip";
    sha256 = "0sl54fsb2gz6dy0bwdscpdq1ab6ph5b7zald3bwzgkqsvna7p1jr";
  } else throw "Unsupported architecture";

  buildInputs = [ makeWrapper ];
  installPhase = ''
    cp -r ./ $out
    mkdir $out/oldbin
    mv $out/bin/IceSL-slicer $out/oldbin/IceSL-slicer
    runHook postInstall
  '';

  postInstall = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lpath}" \
      $out/oldbin/IceSL-slicer
    makeWrapper $out/oldbin/IceSL-slicer $out/bin/icesl --prefix PATH : ${dialog}/bin
  '';

  meta = with lib; {
    description = "IceSL is a GPU-accelerated procedural modeler and slicer for 3D printing.";
    homepage = http://shapeforge.loria.fr/icesl/index.html;
    license = licenses.inria-icesl;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ mgttlinger ];
  };
}
