{ stdenv, fetchurl, patchelf, makeWrapper, xorg, fontconfig, freetype, gcc, gcc-unwrapped }:

stdenv.mkDerivation rec {
  pname = "IPMIView";
  version = "2.16.0";
  buildVersion = "190815";

  src = fetchurl {
    url = "https://www.supermicro.com/wftp/utility/IPMIView/Linux/IPMIView_${version}_build.${buildVersion}_bundleJRE_Linux_x64.tar.gz";
    sha256 = "0qw9zfnj0cyvab7ndamlw2y0gpczjhh1jkz8340kl42r2xmhkvpl";
  };

  nativeBuildInputs = [ patchelf makeWrapper ];

  buildPhase = with xorg; ''
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ libX11 libXext libXrender libXtst libXi ]}" ./jre/lib/amd64/libawt_xawt.so
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ freetype ]}" ./jre/lib/amd64/libfontmanager.so
    patchelf --set-rpath "${gcc-unwrapped.lib}/lib" ./libiKVM64.so
    patchelf --set-rpath "${gcc.cc}/lib:$out/jre/lib/amd64/jli" --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./jre/bin/java
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out/

    # LD_LIBRARY_PATH: fontconfig is used from java code
    makeWrapper $out/jre/bin/java $out/bin/IPMIView \
      --set LD_LIBRARY_PATH "${stdenv.lib.makeLibraryPath [ fontconfig ]}" \
      --prefix PATH : "$out/jre/bin" \
      --add-flags "-jar $out/IPMIView20.jar" \
  '';

  meta = with stdenv.lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ vlaci ];
  };
}
