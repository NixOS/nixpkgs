# NOTE: Use the following command to update the package
# ```sh
# nix-shell maintainers/scripts/update.nix --arg commit true --arg predicate '(path: pkg: builtins.elem path [["codebuddy"]])'
# ```
{
  lib,
  stdenvNoCC,
  fetchurl,
  manifest ? lib.importJSON ./manifest.json,
}:
let
  baseUrl = "https://acc-1258344699.cos.accelerate.myqcloud.com/@tencent-ai/codebuddy-code/releases/download";

  # Upstream names its archives after the os/arch pairs it builds for.
  target =
    {
      x86_64-linux = "Linux_x86_64";
      aarch64-linux = "Linux_arm64";
      x86_64-darwin = "Darwin_x86_64";
      aarch64-darwin = "Darwin_arm64";
    }
    .${stdenvNoCC.hostPlatform.system};

  asset = manifest.assets.${target};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codebuddy";
  inherit (manifest) version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "${baseUrl}/${finalAttrs.version}/${asset.file}";
    inherit (asset) sha256;
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D codebuddy -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://www.codebuddy.cn";
    description = "CodeBuddy Code - Intelligent Code Assistant";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "codebuddy";
    maintainers = with lib.maintainers; [ Freed-Wu ];
  };
})
