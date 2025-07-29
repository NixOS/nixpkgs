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
    repo = "nmap-formatter";
    rev = "v${version}";
    hash = "sha256-jpgAcnDDVVboZEMkLIE9ei0oT91Y9yp8KUJkH6LQSY4=";
  };

  vendorHash = "sha256-xOS59co6FE2lJae2VtsBKcGjvmMRiGlmZKbqH++mEYk=";

  meta = {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
