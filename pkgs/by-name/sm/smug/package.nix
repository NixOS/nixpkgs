{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "smug";
<<<<<<< HEAD
  version = "0.3.13";
=======
  version = "0.3.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ivaaaan";
    repo = "smug";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dvgbE1iKPDp8KuOuKJt5ITNDctt5Ej759qdcAIJcBkA=";
=======
    sha256 = "sha256-LiVeLvJrWDAMXawF5leiv3wEbUp5f+YFg4lpqkyf9pI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-N6btfKjhJ0MkXAL4enyNfnJk8vUeUDCRus5Fb7hNtug=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = ''
    installManPage ./man/man1/smug.1
    installShellCompletion completion/smug.{bash,fish}
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/ivaaaan/smug";
    description = "tmux session manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juboba ];
=======
  meta = with lib; {
    homepage = "https://github.com/ivaaaan/smug";
    description = "tmux session manager";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "smug";
  };
}
