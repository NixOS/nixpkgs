{ stdenv, fetchurl, p7zip, win-virtio }:

let
  src_usbdk_x86 = fetchurl {
    url = "http://www.spice-space.org/download/windows/usbdk/UsbDk_1.0.4_x86.msi";
    sha256 = "17hv8034wk1xqnanm5jxs4741nl7asps1fdz6lhnrpp6gvj6yg9y";
  };

  src_usbdk_amd64 = fetchurl {
    url = "http://www.spice-space.org/download/windows/usbdk/UsbDk_1.0.4_x64.msi";
    sha256 = "0alcqsivp33pm8sy0lmkvq7m5yh6mmcmxdl39zjxjra67kw8r2sd";
  };

  src_qxlwddm = fetchurl {
    url = "http://people.redhat.com/~vrozenfe/qxlwddm/qxlwddm-0.11.zip";
    sha256 = "082zdpbh9i3bq2ds8g33rcbcw390jsm7cqf46rrlx02x8r03dm98";
  };

  src_vdagent_x86 = fetchurl {
    url = "http://www.spice-space.org/download/windows/vdagent/vdagent-win-0.7.3/vdagent_0_7_3_x86.zip";
    sha256 = "0d928g49rf4dl79jmvnqh6g864hp1flw1f0384sfp82himm3bxjs";
  };

  src_vdagent_amd64 = fetchurl {
    url = "http://www.spice-space.org/download/windows/vdagent/vdagent-win-0.7.3/vdagent_0_7_3_x64.zip";
    sha256 = "0djmvm66jcmcyhhbjppccbai45nqpva7vyvry6w8nyc0fwi1vm9l";
  };
in

stdenv.mkDerivation  {
  # use version number of qxlwddm as qxlwddm is the most important component
  name = "win-spice-0.11";
  version = "0.11";

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p usbdk/x86 usbdk/amd64
    (cd usbdk/x86; ${p7zip}/bin/7z x ${src_usbdk_x86})
    (cd usbdk/amd64; ${p7zip}/bin/7z x ${src_usbdk_amd64})

    mkdir -p vdagent/x86 vdagent/amd64
    (cd vdagent/x86; ${p7zip}/bin/7z x ${src_vdagent_x86}; mv vdagent_0_7_3_x86/* .; rm -r vdagent_0_7_3_x86)
    (cd vdagent/amd64; ${p7zip}/bin/7z x ${src_vdagent_amd64}; mv vdagent_0_7_3_x64/* .; rm -r vdagent_0_7_3_x64)

    mkdir -p qxlwddm
    (cd qxlwddm; ${p7zip}/bin/7z x ${src_qxlwddm}; mv Win8 w8.1; cd w8.1; mv x64 amd64)
    '';

  installPhase =
    let
      copy_qxl = arch: version: "mkdir -p $out/${arch}/qxl; cp qxlwddm/${version}/${arch}/* $out/${arch}/qxl/. \n";
      copy_usbdk = arch: "mkdir -p $out/${arch}/usbdk; cp usbdk/${arch}/* $out/${arch}/usbdk/. \n";
      copy_vdagent = arch: "mkdir -p $out/${arch}/vdagent; cp vdagent/${arch}/* $out/${arch}/vdagent/. \n";
      # SPICE needs vioserial
      # TODO: Link windows version in win-spice (here) to version used in win-virtio.
      #       That way it would never matter whether vioserial is installed from win-virtio or win-spice.
      copy_vioserial = arch: "mkdir -p $out/${arch}/vioserial; cp ${win-virtio}/${arch}/vioserial/* $out/${arch}/vioserial/. \n";
      copy = arch: version: (copy_qxl arch version) + (copy_usbdk arch) + (copy_vdagent arch) + (copy_vioserial arch);
    in
      (copy "amd64" "w8.1") + (copy "x86" "w8.1");

  meta = with stdenv.lib; {
    description = ''Windows SPICE Drivers'';
    homepage = http://www.spice-space.org;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}
