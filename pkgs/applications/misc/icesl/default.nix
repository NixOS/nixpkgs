{ stdenv, lib, fetchzip, freeglut, libXmu, libXi, libX11, libICE, libGLU, libGL, libSM
, libXext, glibc, lua, luabind, glfw, libgccjit, dialog, makeWrapper
}:
let
  lpath = lib.makeLibraryPath [ libXmu libXi libX11 freeglut libICE libGLU libGL libSM libXext  glibc lua glfw luabind libgccjit ];
in
stdenv.mkDerivation rec {
  pname = "iceSL";
  version = "2.4.1";

  src =  if stdenv.hostPlatform.system == "x86_64-linux" then fetchzip {
    url = "https://icesl.loria.fr/assets/other/download.php?build=${version}&os=amd64";
    extension = "zip";
    sha256 = "0rrnkqkhlsjclif5cjbf17qz64vs95ja49xarxjvq54wb4jhbs4l";
  } else if stdenv.hostPlatform.system == "i686-linux" then fetchzip {
    url = "https://icesl.loria.fr/assets/other/download.php?build=${version}&os=i386";
    extension = "zip";
    sha256 = "0n2yyxzw0arkc70f0qli4n5chdlh9vc7aqizk4v7825mcglhwlyh";
  } else throw "Unsupported architecture";

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    cp -r ./ $out
    rm $out/bin/*.so
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
    description = "GPU-accelerated procedural modeler and slicer for 3D printing";
    homepage = "https://icesl.loria.fr/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.inria-icesl;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ mgttlinger ];
  };
}
