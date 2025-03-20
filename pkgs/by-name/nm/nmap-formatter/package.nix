{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eWrFeADjPUioKuGcC3f/y2ocBwOHa5KN81YjF2dbgoc=";
  };

  vendorHash = "sha256-zYXT5+TLx+Z9WtgDabaUqBdRiaa+tyeQYwENfnv8ARo=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
