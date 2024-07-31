{ stdenv
, lib
, rkbin
, qemu
}:

stdenv.mkDerivation {
  name = "rkboot";

  src = rkbin.src;

  postPatch = ''
    substituteInPlace RKBOOT/*.ini --replace 'PATH=' 'PATH=rkboot/'
  '';

  buildPhase = ''
    mkdir rkboot
    for i in $(ls ./RKBOOT/*.ini)
    do
      # The proprietary, statically linked binaries to perform boot_merge are
      # x86_64 only. Though we use box64 to emulate if building on aarch64-linux
      ${lib.optionalString stdenv.isAarch64 "${qemu}/bin/qemu-x86_64"} ./tools/boot_merger "$i" || true
    done
  '';

  installPhase = ''
    mkdir -p $out
    if [ -z "$(ls -A rkboot)" ]; then
      echo "Error: The 'rkboot' directory is empty."
      exit 1
    else
      mv rkboot $out/bin
    fi
  '';

  meta = with lib; {
    description = "Rockchip proprietary SPL bootloader blobs";
    homepage = "https://github.com/rockchip-linux/rkbin";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
