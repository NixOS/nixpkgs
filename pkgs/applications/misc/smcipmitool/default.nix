{ lib
, stdenv
, fetchurl
, makeWrapper
, patchelf
, fontconfig
, freetype
, gcc
, gcc-unwrapped
, iputils
, psmisc
, xorg }:

stdenv.mkDerivation rec {
  pname = "SMCIPMItool";
  version = "2.27.2_build.230221";

  src = fetchurl {
    url = "https://www.supermicro.com/wdl/utility/SMCIPMItool/Linux/SMCIPMITool_${version}_bundleJRE_Linux_x64.tar.gz";
    hash = "sha256-DL39p3sm72DtxDKPV7aDwfP66Yj1nJ7rafvK/Oj3t8I=";
  };

  nativeBuildInputs = [ patchelf makeWrapper ];
  buildPhase = with xorg;
    let
      stunnelBinary = if stdenv.hostPlatform.system == "x86_64-linux" then "linux/stunnel64"
      else if stdenv.hostPlatform.system == "i686-linux" then "linux/stunnel32"
      else throw "IPMIView is not supported on host ${stdenv.hostPlatform.system}";
    in
  ''
    runHook preBuild

    patchelf --set-rpath "${lib.makeLibraryPath [ libX11 libXext libXrender libXtst libXi ]}" ./jre/lib/libawt_xawt.so
    patchelf --set-rpath "${lib.makeLibraryPath [ freetype ]}" ./jre/lib/libfontmanager.so
    patchelf --set-rpath "${gcc.cc}/lib:$out/jre/lib/jli" --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./jre/bin/java
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./BMCSecurity/${stunnelBinary}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R . $out/

    # LD_LIBRARY_PATH: fontconfig is used from java code
    # PATH: iputils is used for ping, and psmisc is for killall
    # WORK_DIR: unfortunately the ikvm related binaries are loaded from
    #           and user configuration is written to files in the CWD
    makeWrapper $out/jre/bin/java $out/bin/SMCIPMItool \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ fontconfig gcc-unwrapped.lib ]}" \
      --prefix PATH : "$out/jre/bin:${iputils}/bin:${psmisc}/bin" \
      --add-flags "-jar $out/SMCIPMITool.jar"

    runHook postInstall
  '';

  meta = with lib; {
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfree;
    maintainers = with maintainers; [ nyanotech ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
