{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "dyff";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "dyff";
    rev = "v${version}";
    sha256 = "sha256-kmL1WzsfuV6O3mFryQKnUeImisMlLd3K43/00l6Trvs=";
  };

  vendorHash = "sha256-8xXw2ITHqw6dPtRuO4aesJzeobb/QGI+z1tn1ebNdzQ=";

  subPackages = [
    "cmd/dyff"
    "pkg/dyff"
    "internal/cmd"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # test fails with the injected version
  postPatch = ''
    substituteInPlace internal/cmd/cmds_test.go \
      --replace "version (development)" ${version}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/homeport/dyff/internal/cmd.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dyff \
      --bash <($out/bin/dyff completion bash) \
      --fish <($out/bin/dyff completion fish) \
      --zsh <($out/bin/dyff completion zsh)
  '';

  meta = with lib; {
    description = "Diff tool for YAML files, and sometimes JSON";
    mainProgram = "dyff";
    longDescription = ''
      dyff is inspired by the way the old BOSH v1 deployment output reported
      changes from one version to another by only showing the parts of a YAML
      file that change.

      Each difference is referenced by its location in the YAML document by
      using either the Spruce or go-patch path syntax.
    '';
    homepage = "https://github.com/homeport/dyff";
    license = licenses.mit;
    maintainers = with maintainers; [
      edlimerkaj
      jceb
    ];
  };
}
