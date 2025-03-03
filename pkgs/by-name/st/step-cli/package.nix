{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "0.28.2";
in
buildGoModule {
  pname = "step-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-noANDVupzaoWfnESsu3ucd3ZvD3K/56YvYonyp2n0ho=";
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
  '';

  vendorHash = "sha256-rxUzvT5vEzZ5G+YGFEw4L25ZlwEn0wTZJgjsdfloFx8=";

  nativeBuildInputs = [ installShellFiles ];

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
