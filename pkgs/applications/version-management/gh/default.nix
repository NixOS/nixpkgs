{ lib, fetchFromGitHub, buildGoModule, installShellFiles, stdenv, testers, gh }:

buildGoModule rec {
  pname = "gh";
<<<<<<< HEAD
  version = "2.34.0";
=======
  version = "2.29.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Bb0vEaMOjgQ5p9r/tfciKo4/MXjUCUIdoDSB/Bido/8=";
  };

  vendorHash = "sha256-iql/CEWwg6t5k8qOFEQotMUUJd4VQ/H4JcuL2Eunqg0=";
=======
    hash = "sha256-OVZTHgzKGpz+F1hHRmbCgjMJSFFFjL9WQBqtx7vZIHc=";
  };

  vendorHash = "sha256-iTPdOolvWINUSSYiPZAwn5ZF44x/x1tIWnKUHAn8ITA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w" GH_VERSION=${version} bin/gh ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "manpages"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
   '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
  '' + ''
    runHook postInstall
  '';

  # most tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gh;
  };

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    changelog = "https://github.com/cli/cli/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "gh";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ zowoq ];
  };
}
