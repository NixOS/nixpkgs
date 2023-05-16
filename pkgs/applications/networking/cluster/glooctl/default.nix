{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "glooctl";
<<<<<<< HEAD
  version = "1.15.4";
=======
  version = "1.14.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-dQvvWlfCCc9QZFdOryX0bvLVdoBlhVMeP8MqQAYKua4=";
  };

  subPackages = [ "projects/gloo/cli/cmd" ];
  vendorHash = "sha256-FU8Siea+oH4xtSVwGk/dcivS6eNpIkWZiZqQ3EX9dwI=";
=======
    hash = "sha256-g/gn08Mpwocf5SBJu93bMNiAlg9osIWUy0skV3JzmMk=";
  };

  subPackages = [ "projects/gloo/cli/cmd" ];
  vendorHash = "sha256-z1am0HfRrPAg2H7ZAjinoirfmaCFdF1oavVVVKQ3V8o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/glooctl

    export HOME=$TMP
    installShellCompletion --cmd glooctl \
      --bash <($out/bin/glooctl completion bash) \
      --zsh <($out/bin/glooctl completion zsh)
  '';

  ldflags = [ "-s" "-w" "-X github.com/solo-io/gloo/pkg/version.Version=${version}" ];

  meta = with lib; {
    description = "glooctl is the unified CLI for Gloo";
    homepage = "https://docs.solo.io/gloo-edge/latest/reference/cli/glooctl/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nelsonjeppesen ];
  };
}
