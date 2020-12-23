{ mkDerivation, stdenv, fetchurl, glibc, qtbase, qtdeclarative,
  qtsvg, qtwebsockets, qtquickcontrols, qtquickcontrols2,
  qtgraphicaleffects, libsForQt512, libGLU, libGL }:

mkDerivation rec {
  pname = "reMarkable-linux-client";
  version = "unstable-2017-10-27";

  src = fetchurl {
    url = "https://remarkable.engineering/remarkable-linux-client-0.0.5-16-1408-g7eca2b66.tgz";
    sha256 = "1305scjyi4b1wh4vr8ccszz11dvgwyka9hivyzv5j8ynqsnij58s";
  };

  buildInputs = [ stdenv.cc.cc.lib libGLU libGL libsForQt512.karchive
                  qtbase qtdeclarative qtsvg qtbase qtwebsockets
                  qtquickcontrols qtquickcontrols2 qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp reMarkable $out/bin
    cp libpdfium.so.1 $out/lib

    patchelf --set-interpreter \
      "${glibc}/lib/ld-linux-x86-64.so.2" \
      "$out/bin/reMarkable"

    patchelf \
      --set-rpath \
      "$out/lib:${libsForQt512.karchive}/lib:${qtdeclarative}/lib:${qtsvg}/lib:${qtbase.out}/lib:${qtwebsockets}/lib:${libGLU}/lib:${stdenv.cc.cc.lib}/lib:${libGL}/lib" \
      "$out/bin/reMarkable"
  '';
  meta = with stdenv.lib; {
    description = "Linux client for interacting with reMarkable cloud";
    homepage = "https://remarkable.engineering";
    license = licenses.unfree; # no source or license in tarball
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.linux;
  };
}
