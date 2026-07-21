{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  openssl,
  unixtools,
}:
let
  version = "0.30.6";
in
buildGoModule {
  pname = "step-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-fMHvv14ToKq73h3aLJBebzhIJQghfBOX6C0hvDODHN8=";
    # this file change depending on git branch status (via .gitattributes)
    # https://github.com/NixOS/nixpkgs/issues/84312
    postFetch = ''
      rm -f $out/.VERSION
    '';
  };

  ldflags = [
    "-w"
    "-s"
    "-X=main.Version=${version}"
  ];

  preCheck = ''
    # Tries to connect to smallstep.com
    rm command/certificate/remote_test.go

    patchShebangs integration/openssl-jwt.sh
  '';

  vendorHash = "sha256-DTFp9K5iiS50QuD2knN/8miYb2k/7O1d3GyEf79i69Q=";

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [
    openssl
    unixtools.xxd
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd step \
      --bash <($out/bin/step completion bash) \
      --zsh <($out/bin/step completion zsh) \
      --fish <($out/bin/step completion fish)
  '';

  meta = {
    description = "Zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    changelog = "https://github.com/smallstep/cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "step";
  };
}
