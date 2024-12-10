{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGo122Module rec {
  pname = "sops";
  version = "3.9.2";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-v35LRFYdnWigWYlDhrOgSOcCI7SUqJbJHaZvlQ6PC4I=";
  };

  vendorHash = "sha256-dnhrZPXZWeU98+dEaFLIdtcLWgIrh47l+WAxe+F+0/I=";

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.22" "go 1.22.7"
  '';

  subPackages = [ "cmd/sops" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/getsops/sops/v3/version.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd sops --bash ${./bash_autocomplete}
    installShellCompletion --cmd sops --zsh ${./zsh_autocomplete}
  '';

  meta = with lib; {
    homepage = "https://getsops.io/";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${version}/CHANGELOG.rst";
    mainProgram = "sops";
    maintainers = with maintainers; [
      Scrumplex
      mic92
    ];
    license = licenses.mpl20;
  };
}
