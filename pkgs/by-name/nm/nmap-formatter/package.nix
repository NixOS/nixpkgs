{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-jpgAcnDDVVboZEMkLIE9ei0oT91Y9yp8KUJkH6LQSY4=";
  };

  vendorHash = "sha256-xOS59co6FE2lJae2VtsBKcGjvmMRiGlmZKbqH++mEYk=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
