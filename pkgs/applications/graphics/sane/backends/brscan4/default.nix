{ stdenv, lib, fetchurl, callPackage, patchelf, makeWrapper, libusb-compat-0_1 }:
let
  myPatchElf = file: with lib; ''
    patchelf --set-interpreter \
      ${stdenv.cc.libc}/lib/ld-linux${optionalString stdenv.is64bit "-x86-64"}.so.2 \
      ${file}
  '';

  udevRules = callPackage ./udev_rules_type1.nix { };

in
stdenv.mkDerivation rec {
  pname = "brscan4";
  version = "0.4.10-1";
  src = {
    "i686-linux" = fetchurl {
      url = "http://download.brother.com/welcome/dlf006646/${pname}-${version}.i386.deb";
      sha256 = "sha256-ymIAg+rfSYP5uzsAM1hUYZacJ0PXmKEoljNtb0pgGMw=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://download.brother.com/welcome/dlf006645/${pname}-${version}.amd64.deb";
      sha256 = "sha256-Gpr5456MCNpyam3g2qPo7S3aEZFMaUGR8bu7YmRY8xk=";
    };
  }."${stdenv.hostPlatform.system}" or (throw "unsupported system ${stdenv.hostPlatform.system}");

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  nativeBuildInputs = [ makeWrapper patchelf udevRules ];
  buildInputs = [ libusb-compat-0_1 ];
  dontBuild = true;

  postPatch = ''
    ${myPatchElf "opt/brother/scanner/brscan4/brsaneconfig4"}

    RPATH=${libusb-compat-0_1.out}/lib
    for a in usr/lib64/sane/*.so*; do
      if ! test -L $a; then
        patchelf --set-rpath $RPATH $a
      fi
    done
  '';

  installPhase = with lib; ''
    runHook preInstall
    PATH_TO_BRSCAN4="opt/brother/scanner/brscan4"
    mkdir -p $out/$PATH_TO_BRSCAN4
    cp -rp $PATH_TO_BRSCAN4/* $out/$PATH_TO_BRSCAN4
    mkdir -p $out/lib/sane
    cp -rp usr/lib${optionalString stdenv.is64bit "64"}/sane/* $out/lib/sane

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
    runHook postInstall
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "Brother brscan4 sane backend driver";
    homepage = "http://www.brother.com";
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jraygauthier ];
  };
}
