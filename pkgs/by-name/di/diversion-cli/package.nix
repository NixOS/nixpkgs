{
  stdenv,
  fetchurl,
  lib,
  nix-update-script,
}:
let
  srcs = {
    "x86_64-linux" = {
      url = "https://dv-binaries.s3.us-east-2.amazonaws.com/linux_x86_64/dv";
      sha256 = "+LwD6yb5S15R6UtckwsibC0vQB0H4mJ7HgyD4c0S+Gw=";
    };

  };
in
stdenv.mkDerivation {
  pname = "diversion-cli";
  version = "0.7.34";
  src =
    assert lib.assertMsg (builtins.hasAttr stdenv.hostPlatform.system srcs)
      "Diversion CLI is not available for ${stdenv.hostPlatform.system}";
    fetchurl {
      url = srcs.${stdenv.hostPlatform.system}.url;
      sha256 = srcs.${stdenv.hostPlatform.system}.sha256;
    };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p "$out/bin"
    install -D $src $out/bin/dv

    export PATH="$out/bin:$PATH"
  '';

  # nix-shell maintainers/scripts/update.nix --argstr package diversion-cli
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "The official CLI to work with Diversion repositories.";
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
