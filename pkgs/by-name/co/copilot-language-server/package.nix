{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  fetchzip,
  nix-update-script,
}:

let
  arch =
    {
      aarch64-darwin = "arm64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      x86_64-linux = "x64";
    }
    ."${stdenvNoCC.hostPlatform.system}"
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  os =
    {
      aarch64-darwin = "darwin";
      aarch64-linux = "linux";
      x86_64-darwin = "darwin";
      x86_64-linux = "linux";
    }
    ."${stdenvNoCC.hostPlatform.system}"
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  executableName = "copilot-language-server";
  fhs =
    { package }:
    buildFHSEnv {
      name = package.meta.mainProgram;
      version = package.version;
      targetPkgs = pkgs: [ pkgs.stdenv.cc.cc.lib ];
      runScript = lib.getExe package;

      meta = package.meta // {
        description =
          package.meta.description
          + " (FHS-wrapped, expand package details for further information when to use it)";
        longDescription = "Use this version if you encounter an error like `Could not start dynamically linked executable` or `SyntaxError: Invalid or unexpected token` (see nixpkgs issue [391730](https://github.com/NixOS/nixpkgs/issues/391730)).";
      };
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "copilot-language-server";
  version = "1.339.0";

  src = fetchzip {
    url = "https://github.com/github/copilot-language-server-release/releases/download/${finalAttrs.version}/copilot-language-server-native-${finalAttrs.version}.zip";
    hash = "sha256-UgBe78MZla2FLfP10VfM4meMaiZWAyj2PUBiZ7M+OXU=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install "${os}-${arch}/${executableName}" -Dm755 -t "$out"/bin

    runHook postInstall
  '';

  dontStrip = true;

  passthru = {
    updateScript = nix-update-script { };
    fhs = fhs { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/features/copilot";
    license = {
      deprecated = false;
      free = false;
      fullName = "GitHub Copilot Product Specific Terms";
      redistributable = false;
      shortName = "GitHub Copilot License";
      url = "https://github.com/customer-terms/github-copilot-product-specific-terms";
    };
    mainProgram = executableName;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      arunoruto
      wattmto
    ];
  };
})
