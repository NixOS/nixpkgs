{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ghorg";
<<<<<<< HEAD
  version = "1.11.7";
=======
  version = "1.11.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gabrie30";
    repo = "ghorg";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3aFEpSyKICJ6jWZAMprE4nV6OxMFVvM82bmKSV87Sng=";
=======
    sha256 = "sha256-M1Kd0cpV/GRbxGdGs6nMn9DEnUdrSh9J5U52j7Hm6S8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = false;
  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ghorg \
      --bash <($out/bin/ghorg completion bash) \
      --fish <($out/bin/ghorg completion fish) \
      --zsh <($out/bin/ghorg completion zsh)
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Quickly clone an entire org/users repositories into one directory";
    longDescription = ''
      ghorg allows you to quickly clone all of an orgs, or users repos into a
      single directory. This can be useful in many situations including
      - Searching an orgs/users codebase with ack, silver searcher, grep etc..
      - Bash scripting
      - Creating backups
      - Onboarding
      - Performing Audits
    '';
    homepage = "https://github.com/gabrie30/ghorg";
<<<<<<< HEAD
    license = lib.licenses.asl20;
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ vidbina ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ghorg";
  };
}
