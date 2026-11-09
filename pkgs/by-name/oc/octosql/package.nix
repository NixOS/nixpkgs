{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "octosql";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "cube2222";
    repo = "octosql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kzbIts5d2KmFfaAnOdpIXI1fiqBYXe5t981g4Uyk/cc=";
  };

  vendorHash = "sha256-p/2UsvxxywQKtk/9wDa5fjS0z6xLLzDONuQ5AtnUonk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cube2222/octosql/cmd.VERSION=${finalAttrs.version}"
  ];

  postInstall = ''
    rm -v $out/bin/tester
  '';

  meta = {
    description = "Commandline tool for joining, analyzing and transforming data from multiple databases and file formats using SQL";
    homepage = "https://github.com/cube2222/octosql";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "octosql";
  };
})
