{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  delta,
}:

buildGoModule (finalAttrs: {
  pname = "diffnav";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hoikRqhVjbd7hH4H+f5OGq0KdIX1etAJhrRL+QsAkx8=";
  };

  vendorHash = "sha256-VNpmcniSpeocl9B+aNwLh4XPyPnYC8SXowJPYWHyzWs=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
  postInstall = ''
    wrapProgram $out/bin/diffnav \
      --prefix PATH : ${lib.makeBinPath [ delta ]}
  '';

  meta = {
    changelog = "https://github.com/dlvhdr/diffnav/releases/tag/${finalAttrs.src.rev}";
    description = "Git diff pager based on delta but with a file tree, à la GitHub";
    homepage = "https://github.com/dlvhdr/diffnav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      amesgen
      matthiasbeyer
    ];
    mainProgram = "diffnav";
  };
})
