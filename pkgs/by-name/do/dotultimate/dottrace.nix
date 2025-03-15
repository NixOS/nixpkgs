{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dottrace";
  version = "2024.3.4";
  desktopName = "dotTrace";
  code = "DP";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotTrace.linux-x64.2024.3.4.tar.gz";
      hash = "sha256-CCvT7QtVhGCxQueM9Ez+KBeQi612WYritkRGqX4KL0w=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotTrace.linux-arm64.2024.3.4.tar.gz";
      hash = "sha256-+ojPuoIyCmKK60oSA8s4bdl1/E6Np4OLfkl7yG5jFiw=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotTrace.macos-x64.2024.3.4.dmg";
      hash = "sha256-iW1gox4Cb5e1O2wfaV46vWr6rciFbhOe+1DsLmYzEMk=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.4/JetBrains.dotTrace.macos-arm64.2024.3.4.dmg";
      hash = "sha256-CtSGuVe9HDFv7IhHiKtB7uaYFZUW+GEzHu7/SDEKsmU=";
    };
  };

  iconHolder = "JetBrains.dotTrace.Home.Shell.exe";

  executables = [
    "dotTrace"
    "dotTraceViewer"
  ];

  meta = {
    homepage = "https://www.jetbrains.com/profiler";
    description = ".NET Performance Profiler";
    maintainers = with lib.maintainers; [ js6pak ];
  };
}
