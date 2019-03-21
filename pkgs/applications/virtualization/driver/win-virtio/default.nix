{ stdenv, fetchurl, p7zip }:
stdenv.mkDerivation rec {
  name = "win-virtio-${version}";
  version = "0.1.141-1";

  phases = [ "buildPhase" "installPhase" ];

  src = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-${version}/virtio-win.iso";
    sha256 = "0mn5gcgb9dk59nrw9scdza628yiji4vdkxmixikn9v02kgwnkja3";
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
