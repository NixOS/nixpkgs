{
  stdenv,
  fetchurl,
  lib,
  binutils,
  unzip,
  gnutar,
  glibc,
  rsync,
  kmod,
  libxcrypt,
  patchelf,
  pciutils,
  python3,
  usbutils,
  zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mft";
  version = "4.33.0";
  bld = "169";

  src = fetchurl {
    url = "https://www.mellanox.com/downloads/MFT/mft-${finalAttrs.version}-${finalAttrs.bld}-x86_64-deb.tgz";
    sha256 = "sha256-9PRRzKObF9F2WR457fo0wWr5C1HmE9Xi+/+jVmh/18Y=";
  };

  nativeBuildInputs = [
    binutils
    gnutar
    kmod
    python3
    rsync
    unzip
  ];

  phases = [
    "unpackPhase"
    "installPhase"
    "fixupPhase"
  ];

  installPhase = ''
    mkdir $out
    for deb in DEBS/*.deb;do
      ar x $deb
      tar xvf data.tar.xz
      [ -d etc ] && rsync -avz etc $out
      rsync -avz usr/ $out
    done
    mv $out/etc/init.d/mst $out/bin/mst
    rm -rf $out/etc/bash_completion.d
  '';

  postFixup =
    let
      pelf = patchelf + "/bin/patchelf";
    in
    ''
      for bin in $out/bin/*;do
        if file --brief --mime-type "$bin" | grep -q '^application/x-executable$'; then
          ${pelf} \
            --set-interpreter $(${pelf} --print-interpreter ${pelf}) \
            --set-rpath ${
              lib.makeLibraryPath [
                zlib
                glibc
                (lib.getLib stdenv.cc.cc.lib)
              ]
            } \
            $bin
        fi
      done
      find $out/lib -type f | while read -r lib; do
        if file --brief --mime-type "$lib" | grep -q '^application/x-sharedlib$'; then
          ${pelf} \
            --set-rpath ${
              lib.makeLibraryPath [
                zlib
                glibc
                (lib.getLib stdenv.cc.cc.lib)
                libxcrypt
              ]
            } \
            $lib
        fi
      done
      sed -i \
        -e "s,^prefix=.*,prefix=$out,g" \
        -e "s,^lspci=.*,lspci=${pciutils}/bin/lspci,g" \
        -e "s,/sbin/lsmod,${kmod}/bin/lsmod,g" \
        -e "s, lsmod , ${kmod}/bin/lsmod ,g" \
        -e "s,^modprobe=.*,modprobe=${kmod}/bin/modprobe,g" \
        -e "s,/sbin/modprobe,${kmod}/bin/modprobe,g" \
        -e "s, modprobe , ${kmod}/bin/modprobe ,g" \
        -e "s,^PATH=.*,PATH=\"\$PATH:\$mbindir:${
          lib.makeBinPath [
            kmod
            pciutils
            python3
            usbutils
          ]
        }\",g " \
        -e "s,^PYTHON_EXEC,PYTHON_EXEC=${python3}/bin/python,g" \
        -e "s,^mbindir=.*,mbindir=$out/bin,g" \
        -e "s,^mlibdir=.*,mlibdir=$out/lib,g" \
        $out/bin/mst

      rm -rf $out/mft/RPMS
      rmdir $out/etc/init.d
    '';
  meta = {
    homepage = "https://network.nvidia.com/products/adapter-software/firmware-tools";
    description = "NVIDIA Firmware Tools";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ edwtjo ];
    mainProgram = "mst";
    platforms = [
      "x86_64-linux"
    ];
  };
})
