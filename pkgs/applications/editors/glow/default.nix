{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, stdenv
, fetchpatch
}:

buildGoModule rec {
  pname = "glow";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    hash = "sha256-12UziCf3BO1z+W02slNCCvXhIkvZuVgXk++BdHG3gDI=";
  };

  vendorHash = "sha256-xxFC87t12bZKea9Snscul+xx8IGFAcoIr9Z8wxHL7nM=";

  # Remove whenever a release with it is available
  patches = [(fetchpatch {
    url = "https://github.com/charmbracelet/glow/commit/f0734709f0be19a34e648caaf63340938a50caa2.patch";
    name = "go-1-17-patch";
    hash = "sha256-vpMiVb/7SFT9xcSpVGQriEjkexh1F/ljpfpIswdBx2Y=";
  })];

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd glow \
      --bash <($out/bin/glow completion bash) \
      --fish <($out/bin/glow completion fish) \
      --zsh <($out/bin/glow completion zsh)
  '';

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    changelog = "https://github.com/charmbracelet/glow/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne penguwin ];
    mainProgram = "glow";
  };
}
