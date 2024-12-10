{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
}:

stdenv.mkDerivation rec {
  pname = "libsane-dsseries";
  version = "1.0.5-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf100974/${pname}-${version}.x86_64.rpm";
    sha256 = "1wfdbfbf51cc7njzikdg48kwpnpc0pg5s6p0s0y3z0q7y59x2wbq";
  };

  nativeBuildInputs = [ rpmextract ];

  unpackCmd = ''
    mkdir ${pname}-${version} && pushd ${pname}-${version}
    rpmextract $curSrc
    popd
  '';

  patchPhase = ''
    substituteInPlace etc/udev/rules.d/50-Brother_DSScanner.rules \
      --replace 'GROUP="users"' 'GROUP="scanner", ENV{libsane_matched}="yes"'

    mkdir -p etc/sane.d/dll.d
    echo "dsseries" > etc/sane.d/dll.d/dsseries.conf
  '';

  installPhase = ''
    mkdir -p $out
    cp -dr etc $out
    cp -dr usr/lib64 $out/lib
  '';

  preFixup = ''
    for f in `find $out/lib/sane/ -type f`; do
      # Make it possible to find libstdc++.so.6
      patchelf --set-rpath ${stdenv.cc.cc.lib}/lib:$out/lib/sane $f

      # Horrible kludge: The driver hardcodes /usr/lib/sane/ as a dlopen path.
      # We can directly modify the binary to force a relative lookup instead.
      # The new path is NULL-padded to the same length as the original path.
      sed -i "s|/usr/lib/sane/%s|%s\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00|g" $f
    done
  '';

  meta = {
    description = "Brother DSSeries SANE backend driver";
    homepage = "http://www.brother.com";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ callahad ];
  };
}
