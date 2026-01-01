{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  age-plugin-fido2-hmac,
  age-plugin-ledger,
  age-plugin-se,
  age-plugin-sss,
  age-plugin-tpm,
  age-plugin-yubikey,
  age-plugin-1p,
  makeWrapper,
  runCommand,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule (final: {
  pname = "age";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    tag = "v${final.version}";
<<<<<<< HEAD
    hash = "sha256-Qs/q3zQYV0PukABBPf/aU5V1oOhw95NG6K301VYJk8A=";
  };

  vendorHash = "sha256-iVDkYXXR2pXlUVywPgVRNMORxOOEhAmzpSM0xqSQMSQ=";
=======
    hash = "sha256-9ZJdrmqBj43zSvStt0r25wjSfnvitdx3GYtM3urHcaA=";
  };

  vendorHash = "sha256-ilRLEV7qOBZbqzg2XQi4kt0JAb/1ftT4JmahYT0zSRU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X main.Version=v${final.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
=======
    "-X main.Version=${final.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  preInstall = ''
    installManPage doc/*.1
  '';

<<<<<<< HEAD
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
=======
  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${final.pname}" --version)" == "${final.version}" ]]; then
      echo '${final.pname} smoke check passed'
    else
      echo '${final.pname} smoke check failed'
      return 1
    fi
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # plugin test is flaky, see https://github.com/FiloSottile/age/issues/517
  checkFlags = [
    "-skip"
    "TestScript/plugin"
  ];

  # group age plugins together
  passthru.plugins = {
    inherit
      age-plugin-fido2-hmac
      age-plugin-ledger
      age-plugin-se
      age-plugin-sss
      age-plugin-tpm
      age-plugin-yubikey
      age-plugin-1p
      ;
  };

  # convenience function for wrapping sops with plugins
  passthru.withPlugins =
    filter:
<<<<<<< HEAD
    runCommand "age-${final.version}-with-plugins" { nativeBuildInputs = [ makeWrapper ]; } ''
      makeWrapper ${lib.getBin final.finalPackage}/bin/age $out/bin/age \
        --prefix PATH : "${lib.makeBinPath (filter final.passthru.plugins)}"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/FiloSottile/age/releases/tag/v${final.version}";
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = lib.licenses.bsd3;
    mainProgram = "age";
    maintainers = with lib.maintainers; [ tazjin ];
=======
    runCommand "age-${final.version}-with-plugins"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        makeWrapper ${lib.getBin final.finalPackage}/bin/age $out/bin/age \
          --prefix PATH : "${lib.makeBinPath (filter final.passthru.plugins)}"
      '';

  meta = with lib; {
    changelog = "https://github.com/FiloSottile/age/releases/tag/v${final.version}";
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    mainProgram = "age";
    maintainers = with maintainers; [ tazjin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
