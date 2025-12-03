{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ffmpeg_7,
  vulkan-loader,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "palettum";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "arrowpc";
    repo = "palettum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xJGXLJPsfrU/BiS2GuEoJNbXaQZbbkZaArf4otiUqqA=";
  };

  cargoHash = "sha256-c1Xx7U7OU9hcjHNEkFAJ1dYksZq0rL6QcSKGGXuUJYY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg_7
    vulkan-loader
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool that lets you recolor images, GIFs and videos";
    longDescription = ''
      Palettum is a web app and CLI tool that lets you recolor images,
      GIFs, and videos with any custom palette of your choosing. It
      lets you apply any custom palette by either snapping each pixel
      to its closest color (ideal for pixel-art styles), or blending
      the palette as a filter for a smoother effect.
    '';
    homepage = "https://github.com/arrowpc/palettum";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "palettum";
  };
})
