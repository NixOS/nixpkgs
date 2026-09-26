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
  version = "0.87.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-agent";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4a1rOfm4hDwIQBiLJVzwbognv7iPzZOKDSBcqX4cR5E=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ net-tools ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ iproute2 ];

  vendorHash = "sha256-Je8yd551MXmx/VQl1Qu1P8i3GvDiJKr1aK2b5OotZrM=";

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
