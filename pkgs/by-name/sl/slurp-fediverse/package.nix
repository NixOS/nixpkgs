{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:

buildGoModule (finalAttrs: {
  pname = "slurp";
  version = "1.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "vyr";
    repo = "slurp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bqIX+kG/VXLvw/ORqS+Gq8fezd0QW6dlKdLr2vW0YY0=";
  };

  vendorHash = "sha256-i/xoMJORuJbAQW+g9H95xQ5O3811NncCgJIL9OY+B5k=";

  # Tests require networking
  doCheck = false;

  meta = {
    description = "Tool for exporting data from and importing data to Fediverse instances";
    homepage = "https://codeberg.org/vyr/slurp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "slurp";
  };
})
