{ stdenv, fetchurl, lib, patchelf, cdrkit, kernel, which, makeWrapper
, libX11, libXt, libXext, libXmu, libXcomposite, libXfixes, libXrandr, libXcursor}:

stdenv.mkDerivation {
  name = "VirtualBox-GuestAdditions-4.0.2";
  src = fetchurl {
    url = http://download.virtualbox.org/virtualbox/4.0.2/VBoxGuestAdditions_4.0.2.iso;
    sha256 = "4c8726f70d4202747d35e1ad715ca9dcd29be1fe74720492097d7fb83cae7988";
  };
  KERN_DIR = "${kernel}/lib/modules/*/build";
  buildInputs = [ patchelf cdrkit makeWrapper ];

  installPhase = ''
    ensureDir $out
    cp -r install/* $out

  '';
  
  buildCommand = ''
    ${if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" then ''
        isoinfo -J -i $src -x /VBoxLinuxAdditions.run > ./VBoxLinuxAdditions.run
        chmod 755 ./VBoxLinuxAdditions.run
	./VBoxLinuxAdditions.run --noexec --keep
      ''
      else throw ("Architecture: "+stdenv.system+" not supported for VirtualBox guest additions")
    }
    
    # Unpack files
    cd install
    ${if stdenv.system == "i686-linux" then ''
        tar xfvj VBoxGuestAdditions-x86.tar.bz2
      ''
      else if stdenv.system == "x86_64-linux" then ''
        tar xfvj VBoxGuestAdditions-amd64.tar.bz2
      ''
      else throw ("Architecture: "+stdenv.system+" not supported for VirtualBox guest additions")
    }

    
    # Build kernel modules    
    cd src        

    for i in *
    do
	cd $i
	sed -i -e "s/depmod/echo/g" Makefile
	sed -i -e "s/depmod/echo/g" */Makefile
	make
	cd ..
    done

    cd ..
    
    # Change the interpreter for various binaries
    for i in sbin/VBoxService bin/{VBoxClient,VBoxControl}
    do
        ${if stdenv.system == "i686-linux" then ''
          patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $i
	''
	else if stdenv.system == "x86_64-linux" then ''
	  patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $i
	''
	else throw ("Architecture: "+stdenv.system+" not supported for VirtualBox guest additions")
	}
    done

    # Change rpath for various binaries and libraries
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXt}/lib:${libXext}/lib:${libXmu}/lib:${libXfixes}/lib:${libXrandr}/lib:${libXcursor}/lib bin/VBoxClient

    for i in lib/VBoxOGL*.so
    do
        patchelf --set-rpath $out/lib $i
    done
    
    # Remove references to /usr from various scripts and files
    sed -i -e "s|/usr/bin|$out/bin|" share/VBoxGuestAdditions/vboxclient.desktop
    sed -i -e "s|/usr/bin|$out/bin|" bin/VBoxClient-all
    
    # Install binaries
    ensureDir $out/sbin
    install -m 755 sbin/VBoxService $out/sbin

    ensureDir $out/bin
    install -m 755 bin/VBoxClient $out/bin
    install -m 755 bin/VBoxControl $out/bin
    install -m 755 bin/VBoxClient-all $out/bin

    wrapProgram $out/bin/VBoxClient-all \
            --prefix PATH : "${which}/bin"

    # Install OpenGL libraries
    ensureDir $out/lib
    cp -v lib/VBoxOGL*.so $out/lib
    ensureDir $out/lib/dri
    ln -s $out/lib/VBoxOGL.so $out/lib/dri/vboxvideo_dri.so
    
    # Install desktop file
    ensureDir $out/share/autostart
    cp -v share/VBoxGuestAdditions/vboxclient.desktop $out/share/autostart
    
    # Install HAL FDI file
    ensureDir $out/share/hal/fdi/policy
    install -m 644 share/VBoxGuestAdditions/90-vboxguest.fdi $out/share/hal/fdi/policy
    
    # Install Xorg drivers
    ensureDir $out/lib/xorg/modules/{drivers,input}
    install -m 644 lib/VBoxGuestAdditions/vboxvideo_drv_18.so $out/lib/xorg/modules/drivers/vboxvideo_drv.so
    install -m 644 lib/VBoxGuestAdditions/vboxmouse_drv_18.so $out/lib/xorg/modules/input/vboxmouse_drv.so
    
    # Install kernel modules
    cd src
    
    for i in *
    do
        cd $i
	kernelVersion=$(cd ${kernel}/lib/modules; ls)
	export MODULE_DIR=$out/lib/modules/$kernelVersion/misc
	sed -i -e "s|-o root||g" \
	       -e "s|-g root||g" Makefile
	make install
	cd ..
    done    
  '';
  
  meta = {
    description = "Guest additions for VirtualBox";
    longDescriptions = ''
      Various add-ons which makes NixOS work better as guest OS inside VirtualBox.
      This add-on provides support for dynamic resizing of the X Display, shared
      host/guest clipboard support and guest OpenGL support.
    '';
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
