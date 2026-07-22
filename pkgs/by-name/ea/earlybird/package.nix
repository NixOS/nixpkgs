{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  poppler-utils,
  wv,
  unrtf,
  html-tidy,
  makeWrapper,
  # TODO add justext when github.com/JalfResi/justext becomes available
  # justext
}:

buildGoModule (finalAttrs: {
  pname = "earlybird";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "americanexpress";
    repo = "earlybird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P8kA9MJA+2jtVOYLBu0oG9xTUTGCtiX4R+4ecmXDAAw=";
  };

  vendorHash = "sha256-pQ8gSDHsdDT/cgvRB0OSqnMZz2W5vAzFBzph0xksC2o=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    makeWrapper
    gitMinimal
  ];

  checkFlags = [
    "--skip=Test_parseGitFiles"
  ];

  postFixup = ''
    wrapProgram $out/bin/earlybird \
      --prefix PATH : ${
        lib.makeBinPath [
          poppler-utils
          wv
          unrtf
          html-tidy
        ]
      }
  '';

  meta = {
    description = "Sensitive data detection tool capable of scanning source code repositories for passwords, key files, and more";
    mainProgram = "earlybird";
    homepage = "https://github.com/americanexpress/earlybird";
    changelog = "https://github.com/americanexpress/earlybird/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tbutter ];
  };
})
