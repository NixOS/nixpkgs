{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ULoqb9+GQB+Rg5p/Lqa1gHvZDDAmcfNE6FOK/R5mVK8=";
  };

  vendorHash = "sha256-V7Ppb5u6to8bc0TWgJirC04N9lMOYav/dgEPWHzvGro=";

  meta = with lib; {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
