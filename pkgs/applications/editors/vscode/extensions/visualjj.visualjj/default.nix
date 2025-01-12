{
  stdenvNoCC,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-q9ubYkhrV28sB9CV1dyBEIFEkTrkGHRXdz5+4xjeVzI=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-vV5u1QBICz3GIYRgH9UWM38a8YXtvW0u8r7c1SaKwxM=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-fgT4brIhHI6gNCcsbHpz+v4/diyox2VoFlvCnhPIbPM=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-/uuLRkEY430R5RS7B6972iginpA3pWpApjI6RUTxcHM=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.13.4";
    }
    // sources.${stdenvNoCC.system} or (throw "Unsupported system ${stdenvNoCC.system}");

  meta = {
    description = "Jujutsu version control integration, for simpler Git workflow";
    downloadPage = "https://www.visualjj.com";
    homepage = "https://www.visualjj.com";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.drupol ];
  };
}
