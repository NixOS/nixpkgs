{ lib, stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  pname = "win-qemu";
  version = "0.1.105-1";

  dontUnpack = true;

  src = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-${version}/virtio-win.iso";
    sha256 = "065gz7s77y0q9kfqbr27451sr28rm9azpi88sqjkfph8c6r8q3wc";
  };

  buildPhase = ''
    ${p7zip}/bin/7z x $src
  '';

  installPhase =
    let
      copy_pvpanic = arch: version: "mkdir -p $out/${arch}/qemupanic; cp pvpanic/${version}/${arch}/* $out/${arch}/qemupanic/. \n";
      copy_pciserial = arch: "mkdir -p $out/${arch}/qemupciserial; cp qemupciserial/* $out/${arch}/qemupciserial/. \n";
      copy_agent = arch: ''
        mkdir -p $out/${arch}/qemuagent
        cp guest-agent/${if arch=="x86" then "qemu-ga-x86.msi" else "qemu-ga-x64.msi"} $out/${arch}/qemuagent/qemu-guest-agent.msi
        (cd $out/${arch}/qemuagent; ${p7zip}/bin/7z x qemu-guest-agent.msi; rm qemu-guest-agent.msi)
      '';
      copy = arch: version: (copy_pvpanic arch version) + (copy_pciserial arch) + (copy_agent arch);
    in
    (copy "amd64" "w8.1") + (copy "x86" "w8.1");

  meta = with lib; {
    description = "Windows QEMU Drivers";
    homepage = "https://fedoraproject.org/wiki/Windows_Virtio_Drivers";
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
