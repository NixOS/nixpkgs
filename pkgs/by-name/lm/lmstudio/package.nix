{
  lib,
  stdenv,
  callPackage,
  version ? "0.3.6",
  rev ? "8",
  ...
}@args:
let
  pname = "lmstudio";
  meta = {
    description = "LM Studio is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "lmstudio";
    maintainers = with lib.maintainers; [
      cig0
      eeedean
      crertel
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      meta
      ;
    url =
      args.url
        or "https://installers.lmstudio.ai/darwin/arm64/${version}-${rev}/LM-Studio-${version}-${rev}-arm64.dmg";
    hash = args.hash or "sha256-x4IRT1PjBz9eafmwNRyLVq+4/Rkptz6RVWDFdRrGnGY=";
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      meta
      ;
    url =
      args.url
        or "https://installers.lmstudio.ai/linux/x64/${version}-${rev}/LM-Studio-${version}-${rev}-x64.AppImage";
    hash = args.hash or "sha256-laROBUr1HLoaQT6rYhhhulR1KZuKczNomKbrXXkDANY=";
  }
