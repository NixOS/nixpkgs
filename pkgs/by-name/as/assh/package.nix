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
  version = "2.17.4";

  src = fetchFromGitHub {
    repo = "assh";
    owner = "moul";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zX+jHq+xb8Y3lteq0mUm4kkbjq2e3NYW3YC3WOwQJNA=";
  };

  vendorHash = "sha256-DeF1Gb/x8RfQDGEvFkf5w/zOyTypWslKioMAYyMNxx0=";

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
