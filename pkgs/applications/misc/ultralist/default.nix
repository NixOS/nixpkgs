{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "ultralist";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ultralist";
    repo = "ultralist";
    rev = version;
    sha256 = "sha256-GGBW6rpwv1bVbLTD//cU8jNbq/27Ls0su7DymCJTSmY=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  deleteVendor = true;

  vendorSha256 = "sha256-xmJSqeEo8dqbqVSoP7JasIJq9RUrKE0Cma2jSY4Gq+M=";

  meta = with lib; {
    description = "Simple GTD-style todo list for the command line";
    homepage = "https://ultralist.io";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
