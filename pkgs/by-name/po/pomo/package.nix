{
  lib,
  buildGoModule,
  fetchFromGitHub,
  iana-etc,
  libredirect,
  stdenvNoCC,
}:
buildGoModule (finalAttrs: {
  pname = "pomo";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Bahaaio";
    repo = "pomo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gQ7bHQGaQPujpOwVdcwKgiYQjUECi/Pjt5LKwa1v1J8=";
  };

  vendorHash = "sha256-kbTYq4Xc86bcmNMhInq1rwYTbGRmu2TEXT2e7bqT5YY=";

  nativeCheckInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [ libredirect.hook ];

  preCheck = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  meta = {
    description = "Customizable TUI Pomodoro timer with ASCII art, progress bar, notifications, and stats";
    homepage = "https://github.com/Bahaaio/pomo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mugaizzo
    ];
    mainProgram = "pomo";
  };
})
