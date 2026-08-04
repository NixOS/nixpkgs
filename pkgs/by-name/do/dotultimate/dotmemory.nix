{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dotmemory";
  version = "2025.2.4";
  desktopName = "dotMemory";
  code = "DM";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotMemory.linux-x64.2025.2.4.tar.gz";
      hash = "sha256-gd+UyKqM3rPbn9lwYlJmduaMQI4JfLMdQTILUiaALQs=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotMemory.linux-arm64.2025.2.4.tar.gz";
      hash = "sha256-weHWbnW23XfmGlGpXomr/Of7jqr0xtAXD3GHIu1wgYk=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotMemory.macos-x64.2025.2.4.dmg";
      hash = "sha256-e9bgZKoWCeipeSUpUxXaOgATUY+X3eT4bxuwGG8XGkA=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2025.2.4/JetBrains.dotMemory.macos-arm64.2025.2.4.dmg";
      hash = "sha256-gftHaT6tZa6sXTdU4+B1DrRku/A7kD9+ItV103jh3XY=";
    };
  };

  iconHolder = "JetBrains.dotMemory.Standalone.Avalonia.exe";

  meta = {
    homepage = "https://www.jetbrains.com/dotmemory";
    description = ".NET Memory Profiler";
    maintainers = with lib.maintainers; [ js6pak ];
  };
}
