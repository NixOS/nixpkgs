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
  version = "0.8.8.110";

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
    x86_64-darwin = "macos";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchzip {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.zip";
    sha256 = {
      aarch64-linux = "1lcpj1mgkvksq1d08ibh59y0dmdh7zm77wi5ziqhg3p5g9nxyasd";
      armv7l-linux  = "0sljy06302x567jqw5lagbyhpc3j140jk4wccacxjrbb6hcx3l42";
      x86_64-darwin = "1b058s9kny026q395nj99v8hggxkgv43nnjkmx1a2siajw0db94c";
      x86_64-linux  = "1q77cpz4gflrvfz6dm6np8sqbwyr235gq7y4pzs4hnqbrdzd4nwl";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
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
