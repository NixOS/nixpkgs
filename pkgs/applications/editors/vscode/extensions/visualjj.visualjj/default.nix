{
  stdenvNoCC,
  lib,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-zhn3pZ8Q6clAsYXsdHGMYZJHMGL8VGIUs7fsmUkU2nE=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-ubs0zMmPP/YBBZ3Nn41R8b4E2Rwi83xK6EKhsaUHXsk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-GUNJFIiCSXpw/lIfHOerbbs/j3KAut75u08wCktTqCk=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-fL8OmeekDzj3t5lFirc4C5kYlaAGh4/BanmWsPj2BGI=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.19.0";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "Jujutsu version control integration, for simpler Git workflow";
    downloadPage = "https://www.visualjj.com";
    homepage = "https://www.visualjj.com";
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = [ ];
  };
}
