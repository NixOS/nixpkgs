{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_9,
  nix-update-script,
  stdenv,
}:

let
  version = "1.1.6.0";
in
buildDotnetModule {
  pname = "image2display";
  inherit version;

  src = fetchFromGitHub {
    owner = "chenxuuu";
    repo = "image2display";
    tag = version;
    hash = "sha256-ORDxcZMAhJwSNz79qPo56KdQokF8/Rd7bqWr3nAqe2A=";
  };

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnet-sdk_9;

  passthru.updateScript = nix-update-script { };

  projectFile = "Image2Display/Image2Display/Image2Display.csproj";

  postFixup =
    lib.optionalString stdenv.isLinux ''
      rm $out/bin/libHarfBuzzSharp.so
      rm $out/bin/libSkiaSharp.so
    ''
    + lib.optionalString stdenv.isDarwin ''
      rm $out/bin/libAvaloniaNative.dylib
      rm $out/bin/libHarfBuzzSharp.dylib
      rm $out/bin/libSkiaSharp.dylib
    '';

  meta = {
    homepage = "https://github.com/chenxuuu/image2display/blob/master/README_EN.md";
    description = "Cross-platform image and font data processing tool for generating data usable by microcontrollers";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "Image2Display";
    maintainers = with lib.maintainers; [ bubblepipe ];
  };
}
