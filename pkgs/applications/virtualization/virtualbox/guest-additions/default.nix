{ stdenv, fetchurl, lib, patchelf, cdrkit, kernel, which, makeWrapper
, xorg, dbus, virtualbox }:

let
  version = virtualbox.version;
  xserverVListFunc = builtins.elemAt (stdenv.lib.splitString "." xorg.xorgserver.version);
  xserverABI = xserverVListFunc 0 + xserverVListFunc 1;
in

stdenv.mkDerivation {
  name = "VirtualBox-GuestAdditions-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso";
    sha256 = "7458ee5a7121a7d243fd6a7528ba427945d9120c5efc7cd75b3951fb01f09c59";
  };

  KERN_DIR = "${kernel.dev}/lib/modules/*/build";

  hardeningDisable = [ "pic" ];

  buildInputs = [ patchelf cdrkit makeWrapper dbus ];

  installPhase = ''
    mkdir -p $out
    cp -r install/* $out

  '';

  buildCommand = with xorg; ''
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
        find . -type f | xargs sed 's/depmod -a/true/' -i
        make
        cd ..
    done

    cd ..

    # Change the interpreter for various binaries
    for i in sbin/VBoxService bin/{VBoxClient,VBoxControl} lib/VBoxGuestAdditions/mount.vboxsf
    do
        ${if stdenv.system == "i686-linux" then ''
          patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $i
        ''
        else if stdenv.system == "x86_64-linux" then ''
          patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux-x86-64.so.2 $i
        ''
        else throw ("Architecture: "+stdenv.system+" not supported for VirtualBox guest additions")
        }
        patchelf --set-rpath ${lib.makeLibraryPath [ stdenv.cc.cc dbus libX11 libXt libXext libXmu libXfixes libXrandr libXcursor ]} $i
    done

    for i in lib/VBoxOGL*.so
    do
        patchelf --set-rpath ${lib.makeLibraryPath [ "$out" dbus libXcomposite libXdamage libXext libXfixes ]} $i
    done

    # FIXME: Virtualbox 4.3.22 moved VBoxClient-all (required by Guest Additions
    # NixOS module) to 98vboxadd-xclient. For now, just work around it:
    mv lib/VBoxGuestAdditions/98vboxadd-xclient bin/VBoxClient-all

    # Remove references to /usr from various scripts and files
    sed -i -e "s|/usr/bin|$out/bin|" share/VBoxGuestAdditions/vboxclient.desktop
    sed -i -e "s|/usr/bin|$out/bin|" bin/VBoxClient-all

    # Install binaries
    install -D -m 4755 lib/VBoxGuestAdditions/mount.vboxsf $out/bin/mount.vboxsf
    install -D -m 755 sbin/VBoxService $out/bin/VBoxService

    mkdir -p $out/bin
    install -m 755 bin/VBoxClient $out/bin
    install -m 755 bin/VBoxControl $out/bin
    install -m 755 bin/VBoxClient-all $out/bin

    wrapProgram $out/bin/VBoxClient-all \
            --prefix PATH : "${which}/bin"

    # Install OpenGL libraries
    mkdir -p $out/lib
    cp -v lib/VBoxOGL*.so $out/lib
    mkdir -p $out/lib/dri
    ln -s $out/lib/VBoxOGL.so $out/lib/dri/vboxvideo_dri.so

    # Install desktop file
    mkdir -p $out/share/autostart
    cp -v share/VBoxGuestAdditions/vboxclient.desktop $out/share/autostart

    # Install Xorg drivers
    mkdir -p $out/lib/xorg/modules/{drivers,input}
    install -m 644 lib/VBoxGuestAdditions/vboxvideo_drv_${xserverABI}.so $out/lib/xorg/modules/drivers/vboxvideo_drv.so

    # Install kernel modules
    cd src

    for i in *
    do
        cd $i
        kernelVersion=$(cd ${kernel.dev}/lib/modules; ls)
        export MODULE_DIR=$out/lib/modules/$kernelVersion/misc
        find . -type f | xargs sed -i -e "s|-o root||g" \
                                      -e "s|-g root||g"
        make install
        cd ..
    done
  ''; # */

  meta = {
    description = "Guest additions for VirtualBox";
    longDescriptions = ''
      Various add-ons which makes NixOS work better as guest OS inside VirtualBox.
      This add-on provides support for dynamic resizing of the X Display, shared
      host/guest clipboard support and guest OpenGL support.
    '';
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
