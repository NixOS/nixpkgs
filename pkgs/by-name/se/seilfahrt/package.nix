{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pandoc,
}:

buildGoModule (finalAttrs: {
  pname = "seilfahrt";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Nerdbergev";
    repo = "seilfahrt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pn3EsYPhggViL067nk6UhmIULGsf8IYm/dXSDudiZRA=";
  };

  vendorHash = "sha256-CUxUxumji0j9cwrYksJqHq891VlotMrGIrF0vr6wSMs=";

  buildInputs = [ pandoc ];

  meta = {
    description = "Tool to create a wiki page from a HedgeDoc";
    homepage = "https://github.com/Nerdbergev/seilfahrt";
    changelog = "https://github.com/Nerdbergev/seilfahrt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "seilfahrt";
  };
})
