with import ../../.. {};
with vmTools;

rec {


  # Run the PatchELF derivation in a VM.
  buildPatchelfInVM = runInLinuxVM patchelf;


  testRPMImage = makeImageTestScript diskImages.fedora16i386;


  buildPatchelfRPM = buildRPM {
    name = "patchelf-rpm";
    src = patchelf.src;
    diskImage = diskImages.fedora16x86_64;
  };

  
  testUbuntuImage = makeImageTestScript diskImages.ubuntu810i386;

  
  buildInDebian = runInLinuxImage (stdenv.mkDerivation {
    name = "deb-compile";
    src = patchelf.src;
    diskImage = diskImages.ubuntu810i386;
    memSize = 512;
    phases = "sysInfoPhase unpackPhase patchPhase configurePhase buildPhase checkPhase installPhase fixupPhase distPhase";
    sysInfoPhase = ''
      dpkg-query --list
    '';
  });

/*
  testFreeBSD = runInGenericVM {
    name = "aterm-freebsd";
    src = aterm242fixes.src;
    diskImage = "/tmp/freebsd-7.0.qcow";

    postPreVM = ''
      cp $src aterm.tar.bz2
    '';

    buildCommand = ''
      set > /tmp/my-env
      . /mnt/saved-env
      . /tmp/my-env
      unset TEMP
      unset TEMPDIR
      unset TMP
      unset TMPDIR

      set -x

      echo "Hello World!!!"
      mkdir /mnt/out
      echo "bar" > /mnt/out/foo

      cd /tmp
      tar xvf /mnt/aterm.tar.bz2
      cd aterm-*
      ./configure --prefix=/mnt/out
      make
      make install
    '';
  };
*/  

}
