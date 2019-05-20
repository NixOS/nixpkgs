{ stdenv, fetchurl, lib, patchelf, cdrkit, kernel, which, makeWrapper
, zlib, xorg, dbus, virtualbox }:

let
  version = virtualbox.version;
  xserverVListFunc = builtins.elemAt (stdenv.lib.splitString "." xorg.xorgserver.version);

  # Forced to 1.18 in <nixpkgs/nixos/modules/services/x11/xserver.nix>
  # as it even fails to build otherwise.  Still, override this even here,
  # in case someone does just a standalone build
  # (not via videoDrivers = ["vboxvideo"]).
  # It's likely to work again in some future update.
  xserverABI = let abi = xserverVListFunc 0 + xserverVListFunc 1;
    in if abi == "119" || abi == "120" then "118" else abi;
in

stdenv.mkDerivation {
  name = "VirtualBox-GuestAdditions-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso";
    sha256 = "1srcsf9264l5yxbq2x83z66j38blbfrywq5lkzwb5kih6sv548c3";
  };

  KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  KERN_INCL = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/source/include";

  # If you add a patch you probably need this.
  #patchFlags = [ "-p1" "-d" "install/src/vboxguest-${version}" ];

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration";

  nativeBuildInputs = [ patchelf makeWrapper ];
  buildInputs = [ cdrkit ] ++ kernel.moduleBuildDependencies;

  unpackPhase = ''
    ${if stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux" then ''
        isoinfo -J -i $src -x /VBoxLinuxAdditions.run > ./VBoxLinuxAdditions.run
        chmod 755 ./VBoxLinuxAdditions.run
        ./VBoxLinuxAdditions.run --noexec --keep
      ''
      else throw ("Architecture: "+stdenv.hostPlatform.system+" not supported for VirtualBox guest additions")
    }

    # Unpack files
    cd install
    ${if stdenv.hostPlatform.system == "i686-linux" then ''
        tar xfvj VBoxGuestAdditions-x86.tar.bz2
      ''
      else if stdenv.hostPlatform.system == "x86_64-linux" then ''
        tar xfvj VBoxGuestAdditions-amd64.tar.bz2
      ''
      else throw ("Architecture: "+stdenv.hostPlatform.system+" not supported for VirtualBox guest additions")
    }
  '';

  doConfigure = false;

  buildPhase = ''
    # Build kernel modules.
    cd src
    find . -type f | xargs sed 's/depmod -a/true/' -i
    cd vboxguest-${version}
    # Run just make first. If we only did make install, we get symbol warnings during build.
    make
    cd ../..

    # Change the interpreter for various binaries
    for i in sbin/VBoxService bin/{VBoxClient,VBoxControl} other/mount.vboxsf; do
        patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $i
        patchelf --set-rpath ${lib.makeLibraryPath [ stdenv.cc.cc stdenv.cc.libc zlib
          xorg.libX11 xorg.libXt xorg.libXext xorg.libXmu xorg.libXfixes xorg.libXrandr xorg.libXcursor ]} $i
    done

    for i in lib/VBoxOGL*.so
    do
        patchelf --set-rpath ${lib.makeLibraryPath [ "$out"
          xorg.libXcomposite xorg.libXdamage xorg.libXext xorg.libXfixes ]} $i
    done

    # FIXME: Virtualbox 4.3.22 moved VBoxClient-all (required by Guest Additions
    # NixOS module) to 98vboxadd-xclient. For now, just work around it:
    mv other/98vboxadd-xclient bin/VBoxClient-all

    # Remove references to /usr from various scripts and files
    sed -i -e "s|/usr/bin|$out/bin|" other/vboxclient.desktop
    sed -i -e "s|/usr/bin|$out/bin|" bin/VBoxClient-all
  '';

  installPhase = ''
    # Install kernel modules.
    cd src/vboxguest-${version}
    make install INSTALL_MOD_PATH=$out
    cd ../..

    # Install binaries
    install -D -m 755 other/mount.vboxsf $out/bin/mount.vboxsf
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
    cp -v other/vboxclient.desktop $out/share/autostart

    # Install Xorg drivers
    mkdir -p $out/lib/xorg/modules/{drivers,input}
    install -m 644 other/vboxvideo_drv_${xserverABI}.so $out/lib/xorg/modules/drivers/vboxvideo_drv.so
  '';

  # Stripping breaks these binaries for some reason.
  dontStrip = true;

  # Some code dlopen() libdbus, patch RUNPATH in fixupPhase so it isn't stripped.
  postFixup = ''
    for i in $(grep -F libdbus-1.so -l -r $out/{lib,bin}); do
      origRpath=$(patchelf --print-rpath "$i")
      patchelf --set-rpath "$origRpath:${lib.makeLibraryPath [ dbus ]}" "$i"
    done
  '';

  meta = {
    description = "Guest additions for VirtualBox";
    longDescription = ''
      Various add-ons which makes NixOS work better as guest OS inside VirtualBox.
      This add-on provides support for dynamic resizing of the X Display, shared
      host/guest clipboard support and guest OpenGL support.
    '';
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
