{
  lib,
  shader-slang,
  stdenv,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "slang-language-extension";
    publisher = "shader-slang";
    version = "2.0.1";
    hash = "sha256-cMBFksLcEi3OmRpyuk/hMNo5HqsfGvWhheiLg6Dusn0=";
  };

  postInstall =
    let
      target =
        {
          "x86_64-linux" = "linux-x64";
          "aarch64-linux" = "linux-arm64";
          "x86_64-darwin" = "darwin-x64";
          "aarch64-darwin" = "darwin-arm64";
        }
        .${stdenv.hostPlatform.system};
    in
    lib.concatLines (
      [
        "bin=$out/share/vscode/extensions/shader-slang.slang-language-extension/server/bin"
        "rm -r $bin" # `bin/darwin-arm64` is present by default for some reason.
        "mkdir -p $bin/${target}"
      ]
      # https://github.com/shader-slang/slang-vscode-extension/blob/v2.0.1/build_scripts/build-package.sh#L40-L43
      ++ (map (path: "ln -s ${shader-slang}/${path} $bin/${target}/") [
        "lib/libslang${stdenv.hostPlatform.extensions.library}"
        "lib/libslang-glsl-module${stdenv.hostPlatform.extensions.library}"
        "bin/slangd"
      ])
    );

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/shader-slang.slang-language-extension/changelog";
    description = "Extension for the Slang Shading Language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=shader-slang.slang-language-extension";
    homepage = "https://github.com/shader-slang/slang-vscode-extension";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ samestep ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
