{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  zlib,
  openssl,
}: let
  # Architecture-specific configuration
  archConfig =
    if stdenv.hostPlatform.isAarch64
    then {
      arch = "arm64";
      sha256 = "02gjj65pn4yc3nxvj0w71466q17an4bfmd4nq3m1ca9r2cgkpbwy";
    }
    else if stdenv.hostPlatform.isx86_64
    then {
      arch = "x64";
      sha256 = "nDXWD1jzJtsFT+W8EAs3k+17s/15ZtgDbNqA2Pe2Ed4=";
    }
    else throw "Unsupported architecture: ${stdenv.hostPlatform.system}";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "OctoBot";
    version = "2.1.1";

    src = fetchurl {
      url = "https://github.com/Drakkar-Software/${finalAttrs.pname}/releases/download/${finalAttrs.version}/${finalAttrs.pname}_linux_${archConfig.arch}";
      sha256 = archConfig.sha256;
    };

    dontUnpack = true;

    nativeBuildInputs = [
      autoPatchelfHook # Automatically setup the loader, and do the magic
    ];

    buildInputs = [
      openssl # <- provides libssl + libcrypto
      zlib # <- your dependency
    ];
    installPhase = ''
      ls $src
      mkdir -p $out/bin
      cp $src $out/bin/${finalAttrs.pname}
      chmod +x $out/bin/${finalAttrs.pname}
    '';

    meta = {
      changelog = "https://github.com/Drakkar-Software/OctoBot/blob/v${finalAttrs.version}/CHANGELOG.md";
      description = "Octobot is a powerful open-source cryptocurrency trading robot.";
      homepage = "https://www.octobot.cloud";
      license = lib.licenses.gpl3;
      mainProgram = "OctoBot";
      platforms = ["x86_64-linux" "aarch64-linux"];
    };
  })
