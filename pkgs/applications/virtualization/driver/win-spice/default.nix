{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  virtio-win,
}:

let
  version_usbdk = "1.0.22";
  src_usbdk_x86 = fetchurl {
    url = "https://www.spice-space.org/download/windows/UsbDk/UsbDk_${version_usbdk}_x86.msi";
    sha256 = "1vr8kv37wz6p3xhawyhwxv0g7y89igkvx30zwmyvlgnkv3h5i317";
  };
  src_usbdk_amd64 = fetchurl {
    url = "https://www.spice-space.org/download/windows/UsbDk/UsbDk_${version_usbdk}_x64.msi";
    sha256 = "19b64jv6pfimd54y0pphbs1xh25z41bbblz64ih6ag71w6azdxli";
  };

  version_qxlwddm = "0.21";
  src_qxlwddm = fetchurl {
    url = "https://www.spice-space.org/download/windows/qxl-wddm-dod/qxl-wddm-dod-${version_qxlwddm}/spice-qxl-wddm-dod-${version_qxlwddm}.zip";
    sha256 = "0yjq54gxw3lcfghsfs4fzwipa9sgx5b1sn3fss6r5dm7pdvjp20q";
  };

  version_vdagent = "0.10.0";
  src_vdagent_x86 = fetchurl {
    url = "https://www.spice-space.org/download/windows/vdagent/vdagent-win-${version_vdagent}/vdagent-win-${version_vdagent}-x86.zip";
    sha256 = "142c0lqsqry9dclji2225ppclkn13gbjl1j0pzx8fp6hgy4i02c1";
  };
  src_vdagent_amd64 = fetchurl {
    url = "https://www.spice-space.org/download/windows/vdagent/vdagent-win-${version_vdagent}/vdagent-win-${version_vdagent}-x64.zip";
    sha256 = "1x2wcvld531kv17a4ks7sh67nhzxzv7nkhpx391n5vj6d12i8g3i";
  };
in

stdenv.mkDerivation {
  # use version number of qxlwddm as qxlwddm is the most important component
  pname = "win-spice";
  version = version_qxlwddm;

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p usbdk/x86 usbdk/amd64
    (cd usbdk/x86; ${p7zip}/bin/7z x -y ${src_usbdk_x86})
    (cd usbdk/amd64; ${p7zip}/bin/7z x -y ${src_usbdk_amd64})

    mkdir -p vdagent/x86 vdagent/amd64
    (cd vdagent/x86; ${p7zip}/bin/7z x -y ${src_vdagent_x86}; mv vdagent-win-${version_vdagent}-x86/* .; rm -r vdagent-win-${version_vdagent}-x86)
    (cd vdagent/amd64; ${p7zip}/bin/7z x -y ${src_vdagent_amd64}; mv vdagent-win-${version_vdagent}-x64/* .; rm -r vdagent-win-${version_vdagent}-x64)

    mkdir -p qxlwddm
    (cd qxlwddm; ${p7zip}/bin/7z x -y ${src_qxlwddm}; cd w10)

    runHook postBuild
  '';

  installPhase =
    let
      copy_qxl =
        arch: version: "mkdir -p $out/${arch}/qxl; cp qxlwddm/${version}/${arch}/* $out/${arch}/qxl/. \n";
      copy_usbdk = arch: "mkdir -p $out/${arch}/usbdk; cp usbdk/${arch}/* $out/${arch}/usbdk/. \n";
      copy_vdagent =
        arch: "mkdir -p $out/${arch}/vdagent; cp vdagent/${arch}/* $out/${arch}/vdagent/. \n";
      # SPICE needs vioserial
      # TODO: Link windows version in win-spice (here) to version used in virtio-win.
      #       That way it would never matter whether vioserial is installed from virtio-win or win-spice.
      copy_vioserial =
        arch: version:
        "mkdir -p $out/${arch}/vioserial; cp ${virtio-win}/vioserial/${version}/${arch}/* $out/${arch}/vioserial/. \n";
      copy =
        arch: version:
        (copy_qxl arch version) + (copy_usbdk arch) + (copy_vdagent arch) + (copy_vioserial arch version);
    in
    ''
      runHook preInstall
      ${(copy "amd64" "w10") + (copy "x86" "w10")}
      runHook postInstall
    '';

  meta = with lib; {
    description = "Windows SPICE Drivers";
    homepage = "https://www.spice-space.org/";
    license = [ licenses.asl20 ]; # See https://github.com/vrozenfe/qxl-dod
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
  };
}
