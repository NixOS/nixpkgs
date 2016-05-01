{ stdenv, fetchurl, callPackage, patchelf, makeWrapper, coreutils, libusb }:

/*


*/

let

  myPatchElf = file: with stdenv.lib; ''
    patchelf --set-interpreter \
      ${stdenv.glibc}/lib/ld-linux${optionalString stdenv.is64bit "-x86-64"}.so.2 \
      ${file}
  '';

  udevRules = callPackage ./udev_rules_type1.nix {};

in

stdenv.mkDerivation rec {

  name = "brscan4-0.4.3-3";
  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf006645/${name}.amd64.deb";
    sha256 = "1nccyjl0b195pn6ya4q0zijb075q8r31v9z9a0hfzipfyvcj57n2";
  };

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  nativeBuildInputs = [ makeWrapper patchelf coreutils udevRules ];
  buildInputs = [ libusb ];
  buildPhase = ":";


  patchPhase = ''
    ${myPatchElf "opt/brother/scanner/brscan4/brsaneconfig4"}

    RPATH=${libusb}/lib
    for a in usr/lib64/sane/*.so*; do
      if ! test -L $a; then
        patchelf --set-rpath $RPATH $a
      fi
    done
  '';

  installPhase = ''

    PATH_TO_BRSCAN4="opt/brother/scanner/brscan4"
    mkdir -p $out/$PATH_TO_BRSCAN4
    cp -rp $PATH_TO_BRSCAN4/* $out/$PATH_TO_BRSCAN4
    mkdir -p $out/lib/sane
    cp -rp usr/lib64/sane/* $out/lib/sane

    # Symbolic links were absolute. Fix them so that they point to $out.
    pushd "$out/lib/sane" > /dev/null
    for a in *.so*; do
      if test -L $a; then
        fixedTargetFileName="$(basename $(readlink $a))"
        unlink "$a"
        ln -s -T "$fixedTargetFileName" "$a"
      fi
    done
    popd > /dev/null

    # Generate an LD_PRELOAD wrapper to redirect execvp(), open() and open64()
    # calls to `/opt/brother/scanner/brscan4`.
    preload=$out/libexec/brother/scanner/brscan4/libpreload.so
    mkdir -p $(dirname $preload)
    gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC

    makeWrapper \
      "$out/$PATH_TO_BRSCAN4/brsaneconfig4" \
      "$out/bin/brsaneconfig4" \
      --set LD_PRELOAD $preload

    mkdir -p $out/etc/sane.d
    echo "brother4" > $out/etc/sane.d/dll.conf

    mkdir -p $out/etc/udev/rules.d
    cp -p ${udevRules}/etc/udev/rules.d/*.rules \
      $out/etc/udev/rules.d
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "Brother brscan4 sane backend driver";
    homepage = http://www.brother.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };
}
