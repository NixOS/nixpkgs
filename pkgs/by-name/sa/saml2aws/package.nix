{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.19";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-5g7mbjBkjNl1xvMMJXcITOZTNWXE7m2WhzzvLuULcuo=";
  };

  vendorHash = "sha256-oCYtEMx3+wK1TyS18iYgRwH3NopWY63xsguvanNDSEo=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "."
    "cmd/saml2aws"
  ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd saml2aws \
      --bash <($out/bin/saml2aws --completion-script-bash) \
      --zsh <($out/bin/saml2aws --completion-script-zsh)
  '';

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    mainProgram = "saml2aws";
    homepage = "https://github.com/Versent/saml2aws";
    license = licenses.mit;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
