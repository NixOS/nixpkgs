{ stdenv
, fetchzip
, alsaLib
, glib
, gst_all_1
, libGLU_combined
, xorg
}:

stdenv.mkDerivation rec {
  pname = "kodelife";
  version = "0.8.5.99";

  src = fetchzip {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-linux-x86_64.zip";
    sha256 = "189i2j6kaygjb5pccynxv4pwqpy67jf9nfi7fjfhbrmjpqnmkp90";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/bin
    mv KodeLife $out/bin
  '';

  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc.lib
      alsaLib
      glib
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      libGLU_combined
      xorg.libX11
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/KodeLife
  '';

  meta = with stdenv.lib; {
    homepage = "https://hexler.net/products/kodelife";
    description = "Real-time GPU shader editor";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" ];
  };
}
