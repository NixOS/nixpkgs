{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dottrace";
  version = "2025.2.4";
  desktopName = "dotTrace";
  code = "DP";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotTrace.linux-x64.2025.2.4.tar.gz";
      hash = "sha256-EOytSRkz6nWUgqa1C2k+FxscPIwF3ukQ90pL6eFPJtw=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotTrace.linux-arm64.2025.2.4.tar.gz";
      hash = "sha256-fWP0d+OFsBeFqP10l+HJDs9vKpF0alzzSumlehfTsQQ=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotTrace.macos-x64.2025.2.4.dmg";
      hash = "sha256-Xt25nlLu+5ZFl9Lv8bknDxtGZ/+q0GRoS8D2kjus71k=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotTrace.macos-arm64.2025.2.4.dmg";
      hash = "sha256-myiXttfWJ3tkbFfprehbxr10QAdENwq0L68bw+S4DdY=";
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
