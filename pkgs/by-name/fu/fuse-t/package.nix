{
  lib,
  stdenv,
  fetchurl,
  libarchive,
  p7zip,
  libtapi,
  fetchFromGitHub,
  cmake,
  libiconv,
  DiskArbitration,
}:

let
  version = "1.0.42";

  # This can be used instead of fuse-t however downstream programs
  # will need to be run with the environment variable `FUSE_NFSSRV_PATH`
  # set to `<fuse-t.binaryDistribution>/bin/go-nfsv4`
  binaryDistribution = stdenv.mkDerivation {
    pname = "fuse-t-binary-dist";
    inherit version;

    src = fetchurl {
      url = "https://github.com/macos-fuse-t/fuse-t/releases/download/${version}/fuse-t-macos-installer-${version}.pkg";
      hash = "sha256-pYrQT05hGDcTPYXebTftvd3xGS8ozGTCa47FvWVZQ68=";
    };

    nativeBuildInputs = [
      libarchive
      p7zip
      libtapi
    ];
    propagatedBuildInputs = [ DiskArbitration ];

    unpackPhase = ''
      7z x $src
      bsdtar -xf Payload~
    '';

    buildPhase = ''
      fuseDir="Library/Application Support/fuse-t"
      sed -i "s|^prefix=.*|prefix=$out|" "$fuseDir/pkgconfig/fuse-t.pc"
      sed -i "s|^\(Cflags: .*\)|\1 -D_FILE_OFFSET_BITS=64|" "$fuseDir/pkgconfig/fuse-t.pc"
      ln -s libfuse-t-${version}.a "$fuseDir/lib/libfuse-t.a"
      ln -s libfuse-t-${version}.dylib "$fuseDir/lib/libfuse-t.dylib"
      rm "$fuseDir/uninstall.sh"
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      mv "$fuseDir/bin" $out
      mv "$fuseDir/include" $out
      mv "$fuseDir/lib" $out
      mv "$fuseDir/pkgconfig" $out/lib
      mv Library $out/Library
      runHook postInstall
    '';

    meta = {
      description = "FUSE-T is a kext-less implementation of FUSE for macOS that uses NFS v4 local server instead of a kernel extension.";
      homepage = "https://www.fuse-t.org/";
      # free for non-commercial use, see: https://github.com/macos-fuse-t/fuse-t/blob/main/License.txt
      license = [ lib.licenses.unfreeRedistributable ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      platforms = lib.platforms.darwin;
    };
  };

  stubs = stdenv.mkDerivation {
    pname = "fuse-t-stubs";
    inherit version;

    src = fetchFromGitHub {
      owner = "macos-fuse-t";
      repo = "libfuse";
      rev = "da72c8b60eb929d86c4594fc1792ae49865cd659";
      hash = "sha256-++edBetY+Xfvp5X4i+mL+FJgJXeV43toDRRKhLHlMhw=";
    };

    patches = [
      ./no-universal-binaries.patch
      ./use-correct-path.patch
    ];

    postPatch = ''
      substituteAllInPlace lib/fuse_darwin_private.h
    '';

    nativeBuildInputs = [
      cmake
      libtapi
    ];

    # TODO: remove `.out` after https://github.com/NixOS/nixpkgs/pull/346043 is merged to `master`
    buildInputs = [
      libiconv.out
      DiskArbitration
    ];

    propagatedBuildInputs = [ DiskArbitration ];

    # Removes a lot of warning spam
    # `warning: 'pthread_setugid_np' is deprecated: Use of per-thread security contexts is error-prone and discouraged.`
    env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

    postBuild = ''
      mkdir -p lib/pkgconfig
      tapi stubify --filetype=tbd-v2 lib/libfuse-t.dylib -o lib/libfuse-t.tbd
      substituteAll ${./fuse-t.pc.in} lib/pkgconfig/fuse-t.pc
    '';

    installPhase = ''
      runHook preInstall
      frameworkDir=$out/Library/Frameworks/fuse_t.framework
      frameworkADir=$frameworkDir/Versions/A
      mkdir -p $out/lib/pkgconfig $out/include/fuse $frameworkADir/Headers $frameworkADir/PrivateHeaders
      cp lib/libfuse-t.a lib/libfuse-t.dylib lib/libfuse-t.tbd $out/lib
      cp lib/pkgconfig/fuse-t.pc $out/lib/pkgconfig
      cd ..
      cp include/fuse* $out/include/fuse
      cp include/fuse* $frameworkADir/Headers
      cp include/fuse* $frameworkADir/PrivateHeaders
      ln -s A $out/Library/Frameworks/fuse_t.framework/Versions/Current
      ln -s Versions/Current/Headers $frameworkDir
      ln -s Versions/Current/PrivateHeaders $frameworkDir
      cp include/config.h include/cuse_*.h lib/fuse_*.h $frameworkADir/PrivateHeaders
      cp include/cuse_*.h $frameworkADir/PrivateHeaders
      cp lib/fuse_*.h $frameworkADir/PrivateHeaders
      runHook postInstall
    '';

    doCheck = false;

    meta = with lib; {
      description = "Library that allows filesystems to be implemented in user space";
      longDescription = ''
        FUSE (Filesystem in Userspace) is an interface for userspace programs to
        export a filesystem to the Linux kernel. The FUSE project consists of two
        components: The fuse kernel module (maintained in the regular kernel
        repositories) and the libfuse userspace library (this package). libfuse
        provides the reference implementation for communicating with the FUSE
        kernel module.
      '';
      homepage = "https://github.com/macos-fuse-t/libfuse";
      platforms = platforms.darwin;
      license = licenses.lgpl21Only;
    };
  };
in
stubs.overrideAttrs {
  pname = "fuse-t";

  postInstall = ''
    cp -RHnv ${binaryDistribution}/. $out
    rm $out/lib/libfuse-t-${version}.a $out/lib/libfuse-t-${version}.dylib
  '';

  passthru = {
    inherit binaryDistribution stubs;
  };

  meta = {
    description = "FUSE-T is a kext-less implementation of FUSE for macOS that uses NFS v4 local server instead of a kernel extension.";
    homepage = "https://www.fuse-t.org/";
    license = [
      # libfuse/stubs
      lib.licenses.lgpl21Only

      # NFS server
      # free for non-commercial use, see: https://github.com/macos-fuse-t/fuse-t/blob/main/License.txt
      lib.licenses.unfreeRedistributable
    ];
    sourceProvenance = [
      # libfuse/stubs
      lib.sourceTypes.fromSource

      # NFS server
      lib.sourceTypes.binaryNativeCode
    ];
    maintainers = [ lib.maintainers.Enzime ];
    platforms = lib.platforms.darwin;
  };
}
