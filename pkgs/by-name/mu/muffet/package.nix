{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-GfRR+9PdfY63Pzv2XZenKs8XXAKRr9qMzcHOVhl+hv4=";
  };

  vendorHash = "sha256-oidOSV8y0VwTabipe7XwurUAra9F65nkTXslwXJ94Jw=";

  meta = {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
