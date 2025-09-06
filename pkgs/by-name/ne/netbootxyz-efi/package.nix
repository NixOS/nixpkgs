{
  lib,
  stdenv,
  fetchurl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netboot.xyz-efi";
  version = "2.0.87";

  src = fetchurl {
    url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${finalAttrs.version}/netboot.xyz.efi";
    hash = "sha256-8kd17ChqLuVH5/OdPc2rVDKEDWHl9ZWLh8k+EBrCGH8=";
  };

  dontUnpack = true;

  postInstall = ''
    cp $src $out
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://netboot.xyz/";
    description = "Tool to boot OS installers and utilities over the network, to be run from a bootloader";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pinpox ];
  };
})
