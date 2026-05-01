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
  version = "0.86.3";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-agent";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7N3yvNMr0aksk5LDt5II7pVGW7DVt1Jk+ywTAm7lFSs=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ net-tools ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ iproute2 ];

  vendorHash = "sha256-5eMSpkePx5mWRURXBzQlxWklozU0iRnhjoju4aHql5Y=";

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
