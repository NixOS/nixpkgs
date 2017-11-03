{ stdenv, lib, docker, vmTools, utillinux, curl, kmod, dhcp, cacert, e2fsprogs }:
let
  nameReplace = name: builtins.replaceStrings ["/" ":"] ["-" "-"] name;
in
# For simplicity we only support sha256.
{ imageName, imageTag ? "latest", imageId ? "${imageName}:${imageTag}"
, sha256, name ? (nameReplace "docker-image-${imageName}-${imageTag}.tar") }:
let
  pullImage = vmTools.runInLinuxVM (
    stdenv.mkDerivation {
      inherit name imageId;

      certs = "${cacert}/etc/ssl/certs/ca-bundle.crt";

      builder = ./pull.sh;

      buildInputs = [ curl utillinux docker kmod dhcp cacert e2fsprogs ];

      outputHashAlgo = "sha256";
      outputHash = sha256;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      preVM = vmTools.createEmptyImage {
        size = 2048;
        fullName = "${name}-disk";
      };

      QEMU_OPTS = "-netdev user,id=net0 -device virtio-net-pci,netdev=net0";
    });
in
  pullImage
