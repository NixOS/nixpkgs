{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = "checkmate";
    rev = "v${version}";
    hash = "sha256-XzzN4oIG6E4NsMGl4HzFlgAGhkRieRn+jyA0bT8fcrg=";
  };

  vendorHash = "sha256-D87b/LhHnu8xE0wRdB/wLIuf5NlqrVnKt2WAF29bdZo=";

  subPackages = [ "." ];

  meta = {
    description = "Pluggable code security analysis tool";
    mainProgram = "checkmate";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
