<<<<<<< HEAD
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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Windows VirtIO Drivers";
    homepage = "https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html";
    changelog = "https://fedorapeople.org/groups/virt/virtio-win/CHANGELOG";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ anthonyroussel ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
=======
{ lib, stdenv, fetchurl, p7zip }:
stdenv.mkDerivation rec {
  pname = "win-virtio";
  version = "0.1.196-1";

  dontUnpack = true;

  src = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-${version}/virtio-win.iso";
    sha256 = "1zj53xybygps66m3v5kzi61vqy987zp6bfgk0qin9pja68qq75vx";
  };

  buildPhase = ''
    runHook preBuild
    ${p7zip}/bin/7z x $src
    runHook postBuild
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
    in ''
      runHook preInstall
      ${lib.concatStringsSep "\n" ((map (copy "amd64" "w10") virtio) ++ (map (copy "x86" "w10") virtio))}
      runHook postInstall
    '';

  meta = with lib; {
    description = "Windows VirtIO Drivers";
    homepage = "https://fedoraproject.org/wiki/Windows_Virtio_Drivers";
    license = [ licenses.bsd3 ];
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
