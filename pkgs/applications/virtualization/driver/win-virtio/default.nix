{ lib, stdenv, fetchurl, libarchive }:
stdenv.mkDerivation rec {
  pname = "win-virtio";
  version = "0.1.229-1";

  src = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-${version}/virtio-win.iso";
    hash = "sha256-yIoN3jRgXq7mz4ifPioMKvPK65G130WhJcpPcBrLu+A=";
  };

  nativeBuildInputs = [
    libarchive
  ];

  unpackCmd = "mkdir source; bsdtar -xf $curSrc -C source";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R ./. $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Windows VirtIO Drivers";
    homepage = "https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html";
    license = [ licenses.bsd3 ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
