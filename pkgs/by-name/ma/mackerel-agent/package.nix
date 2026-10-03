{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  iproute2,
  net-tools,
}:

buildGoModule (finalAttrs: {
  pname = "mackerel-agent";
  version = "0.87.1";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-USuRyit/XEuvdzKweNBat09qwXn+rtsxzqND7KvHUTU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ net-tools ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ iproute2 ];

  vendorHash = "sha256-gTeH3aGKdfyxfl9zY5i5RP2gZCXT9eFSpqr1U9XXWy4=";

  subPackages = [ "." ];

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.gitcommit=v${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/mackerel-agent \
      --prefix PATH : "${lib.makeBinPath finalAttrs.buildInputs}"
  '';

  doCheck = true;

  meta = {
    description = "System monitoring service for mackerel.io";
    mainProgram = "mackerel-agent";
    homepage = "https://github.com/mackerelio/mackerel-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ midchildan ];
  };
})
