{
  stdenv,
  kernel,
  callPackage,
  lib,
  dbus,
  xorg,
  zlib,
  patchelf,
  makeWrapper,
  wayland,
  libX11,
}:
let
  virtualBoxNixGuestAdditionsBuilder = callPackage ./builder.nix { };

  # Specifies how to patch binaries to make sure that libraries loaded using
  # dlopen are found. We grep binaries for specific library names and patch
  # RUNPATH in matching binaries to contain the needed library paths.
  dlopenLibs = [
    {
      name = "libdbus-1.so";
      pkg = dbus;
    }
    {
      name = "libXfixes.so";
      pkg = xorg.libXfixes;
    }
    {
      name = "libXrandr.so";
      pkg = xorg.libXrandr;
    }
    {
      name = "libwayland-client.so";
      pkg = wayland;
    }
    {
      name = "libX11.so";
      pkg = libX11;
    }
    {
      name = "libXt.so";
      pkg = xorg.libXt;
    }
  ];
in
stdenv.mkDerivation {
  pname = "VirtualBox-GuestAdditions";
  version = "${virtualBoxNixGuestAdditionsBuilder.version}-${kernel.version}";

  src = "${virtualBoxNixGuestAdditionsBuilder}/VBoxGuestAdditions-${
    if stdenv.hostPlatform.is32bit then "x86" else "amd64"
  }.tar.bz2";
  sourceRoot = ".";

  KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  KERN_INCL = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/source/include";

  hardeningDisable = [ "pic" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration";

  nativeBuildInputs = [
    patchelf
    makeWrapper
    virtualBoxNixGuestAdditionsBuilder
  ] ++ kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild

    # Build kernel modules.
    cd src/vboxguest-${virtualBoxNixGuestAdditionsBuilder.version}_NixOS
    # Run just make first. If we only did make install, we get symbol warnings during build.
    make
    cd ../..

    # Change the interpreter for various binaries
    for i in sbin/VBoxService bin/{VBoxClient,VBoxControl,VBoxDRMClient} other/mount.vboxsf; do
        patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $i
        patchelf --set-rpath ${
          lib.makeLibraryPath [
            stdenv.cc.cc
            stdenv.cc.libc
            zlib
            xorg.libX11
            xorg.libXt
            xorg.libXext
            xorg.libXmu
            xorg.libXfixes
            xorg.libXcursor
          ]
        } $i
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # Install kernel modules.
    cd src/vboxguest-${virtualBoxNixGuestAdditionsBuilder.version}_NixOS
    make install INSTALL_MOD_PATH=$out KBUILD_EXTRA_SYMBOLS=$PWD/vboxsf/Module.symvers
    cd ../..

    # Install binaries
    install -D -m 755 other/mount.vboxsf $out/bin/mount.vboxsf
    install -D -m 755 sbin/VBoxService $out/bin/VBoxService

    install -m 755 bin/VBoxClient $out/bin
    install -m 755 bin/VBoxControl $out/bin
    install -m 755 bin/VBoxDRMClient $out/bin


    # Don't install VBoxOGL for now
    # It seems to be broken upstream too, and fixing it is far down the priority list:
    # https://www.virtualbox.org/pipermail/vbox-dev/2017-June/014561.html
    # Additionally, 3d support seems to rely on VBoxOGL.so being symlinked from
    # libGL.so (which we can't), and Oracle doesn't plan on supporting libglvnd
    # either. (#18457)

    runHook postInstall
  '';

  # Stripping breaks these binaries for some reason.
  dontStrip = true;

  # Patch RUNPATH according to dlopenLibs (see the comment there).
  postFixup = lib.concatMapStrings (library: ''
    for i in $(grep -F ${lib.escapeShellArg library.name} -l -r $out/{lib,bin}); do
      origRpath=$(patchelf --print-rpath "$i")
      patchelf --set-rpath "$origRpath:${lib.makeLibraryPath [ library.pkg ]}" "$i"
    done
  '') dlopenLibs;

  meta = {
    description = "Guest additions for VirtualBox";
    longDescription = ''
      Various add-ons which makes NixOS work better as guest OS inside VirtualBox.
      This add-on provides support for dynamic resizing of the virtual display, shared
      host/guest clipboard support.
    '';
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.gpl2;
    maintainers = [
      lib.maintainers.sander
      lib.maintainers.friedrichaltheide
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    broken = stdenv.hostPlatform.is32bit && (kernel.kernelAtLeast "5.10");
  };
}
