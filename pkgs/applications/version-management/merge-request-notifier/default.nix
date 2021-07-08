{ stdenv, fetchurl, atomEnv, at-spi2-core, xlibs, gnutar, lib }:
let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;
in stdenv.mkDerivation rec {
  version = "1.7.0";
  name = "merge-request-notifier";
  src = fetchurl {
    url = "https://github.com/codecentric/merge-request-notifier/releases/download/v1.7.0/merge-request-notifier-${version}.tar.xz";
    sha256 = "1gyx67rad2p08yr2ky5js8g6xj4jq97g0j8vmsgqa9jqwvq2f65x";
  };

  phases = "unpackPhase fixupPhase";

  targetPath = "$out/opt/merge-request-notifier";

  unpackPhase = ''
    mkdir -p ${targetPath}
    ${gnutar}/bin/tar xf "$src" --strip 1 -C ${targetPath}
  '';

  rpath = lib.concatStringsSep ":" [
    atomEnv.libPath
    "${at-spi2-core.out}/lib"
    "${xlibs.libX11.out}/lib"
    "${xlibs.libxcb.out}/lib"
    targetPath
  ];

  fixupPhase = ''
    patchelf --set-interpreter "${dynamic-linker}" --set-rpath "${rpath}" ${targetPath}/merge-request-notifier
    patchelf --set-interpreter "${dynamic-linker}" --set-rpath "${rpath}" ${targetPath}/chrome-sandbox
    patchelf --set-rpath "${rpath}" ${targetPath}/libGLESv2.so

    mkdir -p $out/bin
    ln -s ${targetPath}/merge-request-notifier $out/bin/merge-request-notifier
  '';

  meta = with stdenv.lib; {
    description = "Merge Request Notifier";
    longDescription = "This app shows your GitLab merge requests grouped by projects and WIP status. It is accessible from the system tray.";
    homepage = "https://github.com/codecentric/merge-request-notifier";
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ robaca ];
  };
}
