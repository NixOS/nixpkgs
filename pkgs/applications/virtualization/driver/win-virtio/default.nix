{ stdenv, fetchurl, p7zip }:

stdenv.mkDerivation  {
  name = "win-virtio-0.1.105-1";
  version = "0.1.105-1";

  phases = [ "buildPhase" "installPhase" ];

  src = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.105-1/virtio-win.iso";
    sha256 = "065gz7s77y0q9kfqbr27451sr28rm9azpi88sqjkfph8c6r8q3wc";
  };

  buildPhase = ''
    ${p7zip}/bin/7z x $src
    '';

  installPhase =
    let
      copy = arch: version: {input, output}: "mkdir -p $out/${arch}/${output}; cp ${input}/${version}/${arch}/* $out/${arch}/${output}/.";
      virtio = [{input="Balloon"; output="vioballoon";}
                {input="NetKVM"; output="vionet";}
                {input="vioscsi"; output="vioscsi";}
                {input="vioserial"; output="vioserial";}
                {input="viostor"; output="viostor";}
                {input="viorng"; output="viorng";}
               ];
    in
      stdenv.lib.concatStringsSep "\n" ((map (copy "amd64" "w8.1") virtio) ++ (map (copy "x86" "w8.1") virtio));

  meta = with stdenv.lib; {
    description = "Windows VirtIO Drivers";
    homepage = https://fedoraproject.org/wiki/Windows_Virtio_Drivers;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}
