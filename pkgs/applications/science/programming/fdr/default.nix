{
  lib,
  stdenv,
  fetchurl,
  qtbase,
  qtx11extras,
  ncurses5,
  xorg,
  zlib,
  python27Packages,
}:
stdenv.mkDerivation {
  pname = "fdr";
  version = "4.2.7";
  src = fetchurl {
    url = "https://dl.cocotec.io/fdr/fdr-3814-linux-x86_64.tar.gz";
    sha256 = "0cajz1gz4slq9nfhm8dqdgxl0kc950838n0lrf8jw4vl54gv6chh";
  };

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    python27Packages.python
    qtbase
    qtx11extras
    ncurses5
    xorg.libX11
    xorg.libXft
    zlib
  ];

  dontConfigure = true;
  installPhase = ''
    mkdir -p "$out"

    # shipped Qt is buggy
    rm lib/libQt*
    rm -r lib/qt_plugins

    cp -r * "$out"
    ln -s ${ncurses5.out}/lib/libtinfo.so.5 $out/lib/libtinfo.so.5
    ln -s ${qtbase.bin}/${qtbase.qtPluginPrefix} $out/lib/qt_plugins
    ln -s ${zlib.out}/lib/libz.so.1 $out/lib/libz.so.1

    for b in fdr4 _fdr4 refines _refines cspmprofiler cspmexplorerprof
    do
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath "$libPath:$out/lib" \
        "$out/bin/$b"
    done

    for l in corei7/librefines.so \
      libcspm_process_compiler.so \
      libcsp_operators.so \
      _fdr.so \
      libfdr.so \
      libfdr_java.so \
      libprocess_compiler.so \
      librefines_gui.so \
      librefines_licensing.so  \
      libboost_date_time.so.1.60.0 \
      libboost_filesystem.so.1.60.0 \
      libboost_iostreams.so.1.60.0 \
      libboost_program_options.so.1.60.0 \
      libboost_serialization.so.1.60.0 \
      libboost_system.so.1.60.0
    do
      patchelf --set-rpath "$libPath:$out/lib" \
        "$out/lib/$l"
    done
  '';

  meta = with lib; {
    homepage = "https://cocotec.io/fdr/";
    description = "The CSP refinement checker";
    license = licenses.unfreeRedistributable;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickhu ];
  };
}
