{ stdenv, fetchurl, lib, patchelf, cdrkit, kernel
, libX11, libXt, libXext, libXmu, libXcomposite}:

stdenv.mkDerivation {
  name = "VirtualBox-GuestAdditions-3.0.8";
  src = fetchurl {
    url = http://download.virtualbox.org/virtualbox/3.0.8/VBoxGuestAdditions_3.0.8.iso;
    sha256 = "0ia231klahqpn21qkn9x3bvy0mxaz051j8hgqv1afvnx2f3gjsvf";
  };
  KERN_DIR = "${kernel}/lib/modules/*/build";
  buildInputs = [ patchelf cdrkit ];
  buildCommand = ''
    isoinfo -J -i $src -x /VBoxLinuxAdditions-x86.run > ./VBoxLinuxAdditions-x86.run
  
    chmod 755 ./VBoxLinuxAdditions-x86.run
    ./VBoxLinuxAdditions-x86.run --noexec --keep
    cd linux

    # Build kernel modules
    cd module
    for i in `find . -name Makefile`
    do
        sed -i -e "s/depmod/echo/g" $i
    done
    make
    cd ..

    # Change the interpreter for various binaries
    for i in ./{mount.vboxsf,vboxadd-service,VBoxClient,VBoxControl}
    do
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $i
    done

    # Change rpath for various binaries and libraries
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXt}/lib:${libXext}/lib:${libXmu}/lib ./VBoxClient

    for i in ./VBoxOGL{arrayspu,errorspu,feedbackspu,packspu,passthroughspu}.so
    do
        patchelf --set-rpath $out/lib $i
    done

    patchelf --set-rpath $out/lib:${libXcomposite}/lib ./VBoxOGL.so

    # Remove references to /usr from various scripts and files
    sed -i -e "s|/usr/bin|$out/bin|" vboxclient.desktop
    sed -i -e "s|/usr/bin|$out/bin|" 98vboxadd-xclient

    # Install binaries
    ensureDir $out/sbin
    install -m 4755 mount.vboxsf $out/sbin/mount.vboxsf
    install -m 755 vboxadd-service $out/sbin/vboxadd-service

    ensureDir $out/bin
    install -m 755 VBoxControl $out/bin/VBoxControl
    install -m 755 VBoxClient $out/bin/VBoxClient
    install -m 755 VBoxRandR.sh $out/bin/VBoxRandR
    install -m 755 98vboxadd-xclient $out/bin/VBoxClient-all

    # Install OpenGL libraries
    ensureDir $out/lib
    cp -v VBoxOGL*.so $out/lib
    ensureDir $out/lib/dri
    ln -s $out/lib/VBoxOGL.so $out/lib/dri/vboxvideo_dri.so
    
    # Install desktop file
    ensureDir $out/share/autostart
    cp -v vboxclient.desktop $out/share/autostart
    
    # Install HAL FDI file
    ensureDir $out/share/hal/fdi/policy
    install -m 644 90-vboxguest.fdi $out/share/hal/fdi/policy
    
    # Install Xorg drivers
    ensureDir $out/lib/xorg/modules/{drivers,input}
    install -m 644 vboxvideo_drv_15.so $out/lib/xorg/modules/drivers/vboxvideo_drv.so
    install -m 644 vboxmouse_drv_15.so $out/lib/xorg/modules/input/vboxmouse_drv.so
    
    # Install kernel modules
    cd module
    kernelVersion=$(cd ${kernel}/lib/modules; ls)
    export MODULE_DIR=$out/lib/modules/$kernelVersion/misc
    ensureDir $MODULE_DIR    
    make install
    cd vboxvideo_drm
    make install
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
