{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, installShellFiles
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "dasel";
<<<<<<< HEAD
  version = "2.3.6";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = "dasel";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-k+I4n05IbQT7tGzkJ0aPW6kLT1mGqwQOwoKDyal8L3w=";
  };

  vendorHash = "sha256-Gueo8aZS5N1rLqZweXjXv7BLrtShxGDSGfbkYXhy4DQ=";
=======
    sha256 = "sha256-DPfahZIb6Cp+E5GxIqNW+IruDZWBvJTRc7gxQOfeJqA=";
  };

  vendorHash = "sha256-+3RcjOZjmYu4eNpgczwY4Uyz1+poYA/TXc2Mb+VwRKc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w" "-X github.com/tomwright/dasel/v2/internal.Version=${version}"
  ];

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dasel \
      --bash <($out/bin/dasel completion bash) \
      --fish <($out/bin/dasel completion fish) \
      --zsh <($out/bin/dasel completion zsh)
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    if [[ $($out/bin/dasel --version) == "dasel version ${version}" ]]; then
      echo '{ "my": { "favourites": { "colour": "blue" } } }' \
        | $out/bin/dasel put -t json -r json -t string -v "red" "my.favourites.colour" \
        | grep "red"
    else
      return 1
    fi
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Query and update data structures from the command line";
    longDescription = ''
      Dasel (short for data-selector) allows you to query and modify data structures using selector strings.
      Comparable to jq / yq, but supports JSON, YAML, TOML and XML with zero runtime dependencies.
    '';
    homepage = "https://github.com/TomWright/dasel";
    changelog = "https://github.com/TomWright/dasel/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "dasel";
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
