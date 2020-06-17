{ stdenv
, fetchzip
, alsaLib
, glib
, gst_all_1
, libGLU, libGL
, xorg
}:

stdenv.mkDerivation rec {
  pname = "kodelife";
  version = "0.9.0.129";

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
    x86_64-darwin = "macos";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchzip {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.zip";
    sha256 = {
      aarch64-linux = "0z2fqlf156348ha3zhv16kvqdx68fbwbzch2gzjm9x1na9n5k1ra";
      armv7l-linux  = "1ppwgrmgl1j2ws9mhrscvvkamd69a6xw7x35df6d30cyj97r0mzy";
      x86_64-darwin = "0f8vn6m3xzsiyxm2ka5wkbp63wvzrix6g1xrbpvcm3v2llmychkl";
      x86_64-linux  = "035c1nlw0nim057sz3axpkcgkafqbm6gpr8hwr097vlrqll6w3dv";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;
  preferLocalBuild = true;

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
      libGLU libGL
      xorg.libX11
    ];
  in stdenv.lib.optionalString (!stdenv.isDarwin) ''
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
    platforms = [ "aarch64-linux" "armv7l-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
