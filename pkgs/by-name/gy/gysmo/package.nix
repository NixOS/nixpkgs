{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gysmo";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "grosheth";
    repo = "gysmo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJ0+OwE17h+BJpzRnykDCSjB2sHz4qcpcq5YcNdKzVU=";
  };

  vendorHash = null;

  meta = {
    description = "Display system information with a focus on customization and aesthetics";
    longDescription = ''
      Gysmo is a terminal application that lets you display system information in a visually appealing way.
      Although, it is not limited to just system information, as it can also display any text you want.
      It is designed to be highly customizable, allowing users to tailor the output to their preferences.

      The following link contains all the documentation you need to get started:
      https://github.com/grosheth/gysmo/blob/main/README.md
    '';
    homepage = "https://github.com/grosheth/gysmo";
    changelog = "https://github.com/grosheth/gysmo/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grosheth ];
    mainProgram = "gysmo";
    platforms = lib.platforms.linux;
  };
})
