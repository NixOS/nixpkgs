{
  lib,
  stdenv,
  rpmextract,
  patchelf,
  makeWrapper,
  file,
  requireFile,
  glib,
  zlib,
  freetype,
  fontconfig,
  xorg,
  libusb-compat-0_1,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "diamond";
  version = "3.10";

  nativeBuildInputs = [
    rpmextract
    patchelf
    makeWrapper
    file
  ];

  src = requireFile {
    name = "diamond_3_10-base_x64-111-2-x86_64-linux.rpm";
    url = "http://www.latticesemi.com/view_document?document_id=52180";
    sha256 = "ec0b370cf8bd55831eeed7c5eadcabacbd6e63ac657c20209d672119a07a5c0f";
  };

  buildCommand = ''
    origprefix=usr/local/diamond/3.10_x64
    prefix=diamond

    echo "Unpacking $src..."
    rpmextract $src

    # Move $pwd/usr/local/diamond/VERS to $out/diamond, cd.
    mkdir -p $out/$prefix
    rmdir $out/$prefix
    mv $origprefix $out/$prefix

    cd $out

    # Extract all tarballs.
    for tb in \
        cae_library/cae_library.tar.gz \
        embedded_source/embedded_source.tar.gz \
        ispfpga/ispfpga.tar.gz \
        synpbase/synpbase.tar.gz \
        tcltk/tcltk.tar.gz \
        bin/bin.tar.gz \
        examples/examples.tar.gz \
        data/data.tar.gz ; do

        echo "Extracting tarball $prefix/$tb"
        cd $out/$prefix/$(dirname $tb)
        tar xf $(basename $tb)
        rm $(basename $tb)
    done

    # Patch shebangs in start scripts .
    cd $out/$prefix/bin/lin64
    for tool in \
        programmer \
        pgrcmd \
        diamond_env \
        powercal \
        model300 \
        update \
        diamond \
        debugger \
        ddtcmd \
        cableserver \
        revealrva \
        ipexpress \
        fileutility \
        diamond ; do

        echo "Patching script $prefix/bin/lin64/$tool..."
        patchShebangs $tool
    done

    # Patch executable ELFs.
    for path in bin/lin64 ispfpga/bin/lin64 synpbase/linux_a_64 synpbase/linux_a_64/mbin; do
        cd $out/$prefix/$path
        for f in *; do
            if ! file $f | grep -q "ELF 64-bit LSB executable" ; then
                continue
            fi
            echo "Patching ELF $prefix/$path/$f..."
            # We force RPATH otherwise libraries from LD_LIBRARY_PATH (which the
            # tools mangle by themselves) will not be able to find their
            # dependencies from nix.
            patchelf \
                --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                --set-rpath "$libPath:$out/$prefix/bin/lin64:$out/$prefix/ispfpga/bin/lin64" \
                --force-rpath \
                $f
        done
    done

    # Patch absolute /usr/bin/id path in script
    sed -i -e "s#/usr/bin/id#${coreutils}/bin/id#" $out/$prefix/synpbase/bin/config/platform_set

    # Remove 32-bit libz.
    rm $out/$prefix/bin/lin64/libz.{so,so.1}

    # Make wrappers. The purpose of these is just to call the target program
    # using its absolute path - otherwise, it will crash.
    mkdir -p bin
    for tool in diamond pnmainc ddtcmd ; do
        makeWrapper $out/$prefix/bin/lin64/$tool $out/bin/$tool
    done
  '';

  libPath = lib.makeLibraryPath [
    glib
    zlib
    freetype
    fontconfig
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    xorg.libXext
    xorg.libX11
    xorg.libXt
    libusb-compat-0_1
  ];

  meta = {
    description = "Vendor development tools for Lattice FPGA devices";
    longDescription = ''
      Lattice Diamond software is the leading-edge software design environment
      for cost- sensitive, low-power Lattice FPGA architectures. It is the
      next-generation replacement for ispLEVER.
    '';
    homepage = "https://www.latticesemi.com/latticediamond";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
