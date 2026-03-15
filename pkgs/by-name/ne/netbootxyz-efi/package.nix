{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "3.0.0";
  platformMap = {
    aarch64-linux = {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz-arm64.efi";
      hash = "sha256-0i3mKD5t4z3YsvXyNIl0n/4D/pEzoz2meAmqhb+f/9A=";
    };
    x86_64-linux = {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.efi";
      hash = "sha256-xvxF4mPgzcZO6j616FqozL8ObuMRuqKu87TtiPkHa+0=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netboot.xyz-efi";
  inherit version;

  src = fetchurl {
    inherit
      (platformMap.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
      )
      url
      hash
      ;
  };

  dontUnpack = true;

  postInstall = ''
    cp $src $out
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://netboot.xyz/";
    description = "Tool to boot OS installers and utilities over the network, to be run from a bootloader";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames platformMap;
    maintainers = with lib.maintainers; [ pinpox ];
  };
})
