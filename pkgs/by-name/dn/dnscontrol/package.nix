{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
<<<<<<< HEAD
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dnscontrol";
  version = "4.29.0";
=======
  testers,
  dnscontrol,
}:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.27.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-0MwDp2wu/K402It8nqMV+ihVg2eLAyb33Ceo9XLz4EQ=";
  };

  vendorHash = "sha256-zeai1PySgsAK1zkV0Z4JIDTGU/mfqfOwmVdu34wd9w0=";
=======
    tag = "v${version}";
    hash = "sha256-OlXqX26aL08gft8sFPZrYBhf7U4DY46BYqli68xEPbg=";
  };

  vendorHash = "sha256-3JlPT0nL/FzjxH6aWZBwYaNetSEzzEv00/F7bsj4h0Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
<<<<<<< HEAD
    "-X=github.com/StackExchange/dnscontrol/v${lib.versions.major finalAttrs.version}/pkg/version.version=${finalAttrs.version}"
=======
    "-w"
    "-X=github.com/StackExchange/dnscontrol/v${lib.versions.major version}/pkg/version.version=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dnscontrol \
      --bash <($out/bin/dnscontrol shell-completion bash) \
      --zsh <($out/bin/dnscontrol shell-completion zsh)
  '';

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;
=======
  passthru.tests = {
    version = testers.testVersion {
      command = "${lib.getExe dnscontrol} version";
      package = dnscontrol;
    };
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://dnscontrol.org/";
<<<<<<< HEAD
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/v${finalAttrs.version}";
=======
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      zowoq
    ];
    mainProgram = "dnscontrol";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
