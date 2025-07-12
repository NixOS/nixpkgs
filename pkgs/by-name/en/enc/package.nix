{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
}:

buildGoModule rec {
  pname = "enc";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "life4";
    repo = "enc";
    rev = version;
    hash = "sha256-6CUSJCE37R6nypqxTEs4tk/Eqg7+ZNGKPit38Zz3r84=";
  };

  vendorHash = "sha256-LK4WMz6AtFotUklim+ewK+pRn22UjBGxfqP7jBMWCNA=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/life4/enc/version.GitCommit=${version}"
  ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    installShellCompletion --cmd enc \
      --bash <($out/bin/enc completion bash) \
      --fish <($out/bin/enc completion fish) \
      --zsh <($out/bin/enc completion zsh)
  '';

  meta = {
    homepage = "https://github.com/life4/enc";
    changelog = "https://github.com/life4/enc/releases/tag/v${version}";
    description = "Modern and friendly alternative to GnuPG";
    mainProgram = "enc";
    longDescription = ''
      Enc is a CLI tool for encryption, a modern and friendly alternative to GnuPG.
      It is easy to use, secure by default and can encrypt and decrypt files using password or encryption keys,
      manage and download keys, and sign data.
      Our goal was to make encryption available to all engineers without the need to learn a lot of new words, concepts,
      and commands. It is the most beginner-friendly CLI tool for encryption, and keeping it that way is our top priority.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvnstn ];
  };
}
