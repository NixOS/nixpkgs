{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssh,
  makeWrapper,
  ps,
}:

buildGoModule (finalAttrs: {
  pname = "assh";
  version = "2.17.0";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X5UWQe4c+QudmXKjFKafivO/OvdBNzyutrL+CUK0olg=";
  };

  vendorHash = "sha256-EA39KqAN9SHPU362j6/j6okvT+eZb2R4unMA0bB+bVg=";

  ldflags = [
    "-s"
    "-w"
    "-X=moul.io/assh/v2/pkg/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ ps ];

  postInstall = ''
    wrapProgram "$out/bin/assh" \
      --prefix PATH : ${openssh}/bin
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/assh --help > /dev/null
  '';

  meta = {
    description = "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts";
    homepage = "https://github.com/moul/assh";
    changelog = "https://github.com/moul/assh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
