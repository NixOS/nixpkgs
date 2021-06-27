{ lib, stdenv
, fetchzip
, alsa-lib
, glib
, gst_all_1
, libGLU, libGL
, xorg
}:

stdenv.mkDerivation rec {
  pname = "kodelife";
  version = "0.9.8.143";

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchzip {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.zip";
    sha256 = {
      aarch64-linux = "0ryjmpzpfqdqrvqpq851vvrjd8ld5g91gcigpv9rxp3z1b7qdand";
      armv7l-linux  = "08nlwn8ixndqil4m7j6c8gjxmwx8zi3in86arnwf13shk6cds5nb";
      x86_64-linux  = "0kbz7pvh4i4a3pj1vzbzzslha825i888isvsigcqsqvipjr4798q";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;
  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv KodeLife $out/bin
    runHook postInstall
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      alsa-lib
      glib
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      libGLU libGL
      xorg.libX11
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/KodeLife
  '';

  meta = with lib; {
    homepage = "https://hexler.net/products/kodelife";
    description = "Real-time GPU shader editor";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ];
  };
}
