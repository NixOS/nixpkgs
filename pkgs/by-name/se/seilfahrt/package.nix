{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pandoc,
}:

buildGoModule rec {
  pname = "seilfahrt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Nerdbergev";
    repo = "seilfahrt";
    rev = "v${version}";
    hash = "sha256-eQcRS3xyqdtjRki+EPnHIaqUJufniFJCh5qU2Za9kyg=";
  };

  vendorHash = "sha256-JU77EFk8SWgZkN4DEtkKS2MsBH16my4j9X/NJC/r6mI=";

  buildInputs = [ pandoc ];

  meta = with lib; {
    description = "Tool to create a wiki page from a HedgeDoc";
    homepage = "https://github.com/Nerdbergev/seilfahrt";
    changelog = "https://github.com/Nerdbergev/seilfahrt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ xgwq ];
    mainProgram = "seilfahrt";
  };
}
