<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pv-migrate";
  version = "1.3.0";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pv-migrate";
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-J4GsXLff9OQNiLv3AvBLtmz383E2JPEB3VEN3nzE5R8=";
=======
    sha256 = "sha256-M+M2tK40d05AxBmTjYKv5rrebX7g+Za8KX+/Q3aVLwE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "cmd/pv-migrate" ];

<<<<<<< HEAD
  vendorHash = "sha256-PzmNCBTw9AfDUBh/tWlukH5EGJffEBCBT1gJTMIZRO0=";
=======
  vendorHash = "sha256-3uqN6RmkctlE4GuYZQbY6wbHyPBJP15O4Bm0kTtW8qo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pv-migrate \
      --bash <($out/bin/pv-migrate completion bash) \
      --fish <($out/bin/pv-migrate completion fish) \
      --zsh <($out/bin/pv-migrate completion zsh)
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "CLI tool to easily migrate Kubernetes persistent volumes ";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/${version}";
    license = licenses.afl20;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ ivankovnatsky qjoly ];
=======
    maintainers = [ maintainers.ivankovnatsky ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
