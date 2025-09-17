{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.13";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-36pdesO1jfCMue4Equ+qFpkjN2tXbOpQ32P9a/c+7aA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-IyrySlg2zj+vqrFR821zdysVguh4UZG1bxnC+GVoLr4=";

  ldflags = [
    "-w"
    "-s"
  ];

  postInstall = ''
    installShellCompletion --cmd crawley \
      --bash <(echo "complete -C $out/bin/crawley crawley") \
      --zsh <(echo "complete -o nospace -C $out/bin/crawley crawley")
  '';

  meta = with lib; {
    description = "Unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = licenses.mit;
    maintainers = with maintainers; [ ltstf1re ];
    mainProgram = "crawley";
  };
}
