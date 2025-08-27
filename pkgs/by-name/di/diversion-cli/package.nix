{
  stdenv,
  fetchurl,
  lib,
  nix-update-script,
}:
let
  srcs = {
    "x86_64-linux" = {
      url = "https://archive.org/download/diversion-cli/dv_linux_x86_64_0-7-195";
      sha256 = "15fDNp4isdgmMkL6g+LVC90S6FItoT29X3cCIqtbxLc=";
    };

  };
in
stdenv.mkDerivation {
  pname = "diversion-cli";
  version = "0.7.195";
  src =
    assert lib.assertMsg (builtins.hasAttr stdenv.hostPlatform.system srcs)
      "Diversion CLI is not available for ${stdenv.hostPlatform.system}";
    fetchurl {
      url = srcs.${stdenv.hostPlatform.system}.url;
      sha256 = srcs.${stdenv.hostPlatform.system}.sha256;
    };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    install -D $src $out/bin/dv
    runHook postInstall
  '';

  # nix-shell maintainers/scripts/update.nix --argstr package diversion-cli
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Official CLI to work with Diversion repositories";
    homepage = "https://diversion.dev";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "dv";
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [
      kggx
    ];
  };
}
