{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-dI5yIP5uUmM9pyMpvvdrk8/0jE/REkU/m9BF081LwMU=";
  };

  cargoSha256 = "sha256-l3Ikr4IyUsHItJIC4BaIZZb6vio3bchumbbPI+nxIjQ=";

  cargoBuildFlags = [ "--features embed_runtime" ];

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ yusdacra ];
  };
}
