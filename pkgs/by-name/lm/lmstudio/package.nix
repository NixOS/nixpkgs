{
  lib,
  stdenv,
  callPackage,
  version ? "0.3.14",
  rev ? "3",
  ...
}@args:
let
  pname = "lmstudio";
  packageVersion = "${version}-${rev}"; # Combine version and rev
  meta = {
    description = "LM Studio is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "lm-studio";
    maintainers = with lib.maintainers; [ crertel ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    broken = stdenv.hostPlatform.isDarwin; # Upstream issue: https://github.com/lmstudio-ai/lmstudio-bug-tracker/issues/347
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit pname meta;
    version = packageVersion;
    url =
      args.url
        or "https://installers.lmstudio.ai/darwin/arm64/${version}-${rev}/LM-Studio-${version}-${rev}-arm64.dmg";
    hash = args.hash or "sha256-doAhCbWFwDWlBQ+4YfJz6p7I4NZJxIOtdLYTr3mOGds=";
  }
else
  callPackage ./linux.nix {
    inherit pname meta;
    version = packageVersion;
    url =
      args.url
        or "https://installers.lmstudio.ai/linux/x64/${version}-${rev}/LM-Studio-${version}-${rev}-x64.AppImage";
    hash = args.hash or "sha256-IIJMk0cfLQdrx0nTSbpsbqOvD+f/qrH+rGdYN4mygaw=";
  }
