{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "coze";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "Cyphrme";
    repo = "Coze_cli";
    rev = "v${version}";
    hash = "sha256-/Cznx5Q0a9vVrC4oAoBmAkejT1505AQzzCW/wi3itv4=";
  };

  vendorHash = "sha256-MdU6fls9jQ51uCa+nB8RF8XDoZ3XgGowUGcSOAK/k+4=";

  postInstall = ''
    mv $out/bin/coze_cli $out/bin/coze
  '';

  meta = with lib; {
    description = "CLI client for Coze, a cryptographic JSON messaging specification";
    mainProgram = "coze";
    homepage = "https://github.com/Cyphrme/coze_cli";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ qbit ];
  };
}
