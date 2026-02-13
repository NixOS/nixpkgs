{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  delta,
}:

buildGoModule (finalAttrs: {
  pname = "diffnav";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EkJim0YCdImlf7cNELMwXMQEJPZxSBbmUH0rnNkCuOM=";
  };

  vendorHash = "sha256-/GwIxSyH7maY2m9CcqUs3aeX/5OX0VsvUoOGWkBzJ9M=";

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
