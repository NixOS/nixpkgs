{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-Ai+Y4WoU0REmo9ECsrV/i0PnPY+gO2+22np+nVH3Xsc=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-bI7PdUl+/kBx4F9T+tvF7QHNQ2pSvRjT31O/nIUvUAE=";

  ldflags = [ "-w" "-s" ];

  postInstall = ''
    installShellCompletion --cmd crawley \
      --bash <(echo "complete -C $out/bin/crawley crawley") \
      --zsh <(echo "complete -o nospace -C $out/bin/crawley crawley")
  '';

  meta = with lib; {
    description = "The unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = licenses.mit;
    maintainers = with maintainers; [ ltstf1re ];
    mainProgram = "crawley";
  };
}
