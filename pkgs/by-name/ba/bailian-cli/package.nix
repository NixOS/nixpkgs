# NOTE: Use the following command to update the package
# ```sh
# nix-shell maintainers/scripts/update.nix --arg commit true --arg predicate '(path: pkg: builtins.elem path [["bailian-cli"]])'
# ```
{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  manifest ? lib.importJSON ./manifest.json,
}:
let
  baseUrl = "https://bailian-wiki.oss-cn-hangzhou.aliyuncs.com/release";

  assetKey =
    {
      x86_64-linux = "linux-x64";
      aarch64-darwin = "darwin-arm64";
      x86_64-darwin = "darwin-x64";
    }
    .${stdenvNoCC.hostPlatform.system};

  asset = manifest.assets.${assetKey};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bailian-cli";
  inherit (manifest) version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "${baseUrl}/v${finalAttrs.version}/${asset.file}";
    inherit (asset) sha256;
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D ${asset.inner} $out/bin/bl

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://help.aliyun.com/zh/model-studio/developer-reference/getting-started";
    description = "Alibaba Cloud Bailian CLI - Command-line tool for Alibaba Cloud Model Studio";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "bl";
    maintainers = with lib.maintainers; [ Freed-Wu ];
  };
})
