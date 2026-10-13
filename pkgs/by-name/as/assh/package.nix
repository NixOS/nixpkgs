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
  version = "2.17.3";

  src = fetchFromGitHub {
    repo = "assh";
    owner = "moul";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CH6QM/dy5fKo7Tq2ekrc06iqjJDZl8JHMG7jalho7BI=";
  };

  vendorHash = "sha256-ENCJNgMLTZDlKL0DIt48F1G8TYo2blPdsFH6v8dNC8w=";

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
