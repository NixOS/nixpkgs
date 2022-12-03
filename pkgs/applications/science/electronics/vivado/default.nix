{ stdenv
, lib
, coreutils
, fetchurl
, patchelf
, procps
, makeWrapper
, requireFile
, ncurses5
, zlib
, libuuid
, libSM
, libICE
, libX11
, libXrender
, libxcb
, libXext
, libXtst
, libXi
, glib
, freetype
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "vivado";
  version = "2017.2";

  buildInputs = [
    patchelf
    procps
    ncurses5
    makeWrapper
    coreutils
  ];

  # requireFile prevents rehashing each time, which saves time during
  # rebuilds.
  src = requireFile rec {
    name = "Xilinx_Vivado_SDK_2017.2_0616_1.tar.gz";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Login to Xilinx, download from
      https://www.xilinx.com/support/download.html,
      rename the file to ${name}, and add it to the nix store with
      "nix-prefetch-url file:///path/to/${name}".
    '';
    sha256 = "06pb4wjz76wlwhhzky9vkyi4aq6775k63c2kw3j9prqdipxqzf9j";
  };

  postPatch = ''
    patchShebangs xsetup

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             tps/lnx64/jre/bin/java

    sed -i -- 's|/bin/rm|rm|g' xsetup
  '';

  buildPhase = ''
    echo "running installer..."

    cat <<EOF > install_config.txt
    Edition=Vivado HL WebPACK
    Destination=$out/opt
    Modules=Software Development Kit (SDK):1,DocNav:0,Kintex UltraScale:0,Zynq-7000:1,System Generator for DSP:0,Artix-7:1,Kintex-7:0
    InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0
    CreateProgramGroupShortcuts=0
    ProgramGroupFolder=Xilinx Design Tools
    CreateShortcutsForAllUsers=0
    CreateDesktopShortcuts=0
    CreateFileAssociation=0
    EOF

    mkdir -p $out/opt

    # The installer will be killed as soon as it says that post install tasks have failed.
    # This is required because it tries to run the unpatched scripts to check if the installation
    # has succeeded. However, these scripts will fail because they have not been patched yet,
    # and the installer will proceed to delete the installation if not killed.
    (./xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt || true) | while read line
    do
        [[ "''${line}" == *"Execution of Pre/Post Installation Tasks Failed"* ]] && echo "killing installer!" && ((pkill -9 -f "tps/lnx64/jre/bin/java") || true)
        echo ''${line}
    done
    # Patch installed files
    patchShebangs $out/opt/Vivado/$version/bin
    patchShebangs $out/opt/SDK/$version/bin
    echo "Shebangs patched"
    # Hack around lack of libtinfo in NixOS
    ln -s $ncurses/lib/libncursesw.so.6 $out/opt/Vivado/$version/lib/lnx64.o/libtinfo.so.5
    ln -s $ncurses/lib/libncursesw.so.6 $out/opt/SDK/$version/lib/lnx64.o/libtinfo.so.5
    # Patch ELFs
    for f in $out/opt/Vivado/$version/bin/unwrapped/lnx64.o/*
    do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f || true
    done
    for f in $out/opt/SDK/$version/bin/unwrapped/lnx64.o/*
    do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f || true
    done
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/SDK/$version/eclipse/lnx64.o/eclipse
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/SDK/$version/tps/lnx64/jre/bin/java
    echo "ELFs patched"
    wrapProgram $out/opt/Vivado/$version/bin/vivado --prefix LD_LIBRARY_PATH : "$libPath"
    wrapProgram $out/opt/SDK/$version/bin/xsdk --prefix LD_LIBRARY_PATH : "$libPath"
    wrapProgram $out/opt/SDK/$version/eclipse/lnx64.o/eclipse --prefix LD_LIBRARY_PATH : "$libPath"
    wrapProgram $out/opt/SDK/$version/tps/lnx64/jre/bin/java --prefix LD_LIBRARY_PATH : "$libPath"
    # wrapProgram on its own will not work because of the way the Vivado script runs ./launch
    # Therefore, we need Even More Patches...
    sed -i -- 's|`basename "\$0"`|vivado|g' $out/opt/Vivado/$version/bin/.vivado-wrapped
    sed -i -- 's|`basename "\$0"`|xsdk|g' $out/opt/SDK/$version/bin/.xsdk-wrapped
    # Add vivado and xsdk to bin folder
    mkdir $out/bin
    ln -s $out/opt/Vivado/$version/bin/vivado $out/bin/vivado
    ln -s $out/opt/SDK/$version/bin/xsdk $out/bin/xsdk
  '';

  dontInstall = true;

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    ncurses5
    zlib
    libuuid
    libSM
    libICE
    libX11
    libXrender
    libxcb
    libXext
    libXtst
    libXi
    glib
    freetype
    gtk2
  ];

  meta = with lib; {
    description = "Xilinx Vivado";
    homepage = "https://www.xilinx.com/products/design-tools/vivado.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
