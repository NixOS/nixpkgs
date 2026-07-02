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
  version = "0.85.2";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-agent";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3A3x32JytJGXebgZeJcToHXNqRB+rbyziT5Zwgc9rEM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ net-tools ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ iproute2 ];

  vendorHash = "sha256-Ubk/ms/3FwH1ZqZ5uTy0MubXhrKBoeaC85Y1KKH5cIw=";

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
