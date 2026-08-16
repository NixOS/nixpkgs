{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "awsweeper";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = "awsweeper";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5D/4Z8ADlA+4+2EINmP5OfX5exzhfbq2TydPRlJDA6Y=";
  };

  vendorHash = "sha256-jzK56x5mzQkD3tSs6X0Z2Zn1OLXFHgWHz0YLZ3m3NS4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/jckuester/awsweeper/internal.version=${finalAttrs.version}"
    "-X github.com/jckuester/awsweeper/internal.commit=${finalAttrs.src.rev}"
    "-X github.com/jckuester/awsweeper/internal.date=unknown"
  ];

  doCheck = false;

  meta = {
    description = "Tool to clean out your AWS account";
    homepage = "https://github.com/jckuester/awsweeper";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "awsweeper";
  };
})
