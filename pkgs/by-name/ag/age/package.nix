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
}:

buildGoModule (final: {
  pname = "age";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    tag = "v${final.version}";
    hash = "sha256-9ZJdrmqBj43zSvStt0r25wjSfnvitdx3GYtM3urHcaA=";
  };

  vendorHash = "sha256-ilRLEV7qOBZbqzg2XQi4kt0JAb/1ftT4JmahYT0zSRU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${final.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  preInstall = ''
    installManPage doc/*.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${final.pname}" --version)" == "${final.version}" ]]; then
      echo '${final.pname} smoke check passed'
    else
      echo '${final.pname} smoke check failed'
      return 1
    fi
  '';

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
  };
})
