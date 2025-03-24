{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "0.28.6";
in
buildGoModule {
  pname = "step-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-9tw/d6n6tzhBhBqizDG1dGhj8se9GF2DtrfYwwhvsLs=";
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

  vendorHash = "sha256-+pHc2uBgQwMkJ7BTgHGHDPgfBpLlN0Yxf+6Enhb7cys=";

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
