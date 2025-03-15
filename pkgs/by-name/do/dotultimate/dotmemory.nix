{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dotmemory";
  version = "2024.3.4";
  desktopName = "dotMemory";
  code = "DM";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotMemory.linux-x64.2024.3.4.tar.gz";
      hash = "sha256-5aDFoQRfGdA5zMTR4DBFNyd8/5xp3sDuBCnwuDUNk38=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotMemory.linux-arm64.2024.3.4.tar.gz";
      hash = "sha256-Eo015OL5eAnxHBOq2l652tnqS38rWgfZh3E+LPsMF+4=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotMemory.macos-x64.2024.3.4.dmg";
      hash = "sha256-Znad6IBvv/zxEyI1rSq8ONsW9+JgfhMBDIfzaEZQlfE=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotMemory.macos-arm64.2024.3.4.dmg";
      hash = "sha256-g9U67Vl9MCJiwGBHvL0yyBSHfkif6XdZED+qmmYwU7k=";
    };
  };

  iconHolder = "JetBrains.dotMemory.Standalone.Avalonia.exe";

  meta = {
    homepage = "https://www.jetbrains.com/dotmemory";
    description = ".NET Memory Profiler";
    maintainers = with lib.maintainers; [ js6pak ];
  };
}
