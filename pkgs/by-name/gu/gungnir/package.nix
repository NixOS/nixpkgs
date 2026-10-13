{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gungnir";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "gungnir";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rmv/EmG8tsno8GVPY079zS9UZ8UE/uxbtO+D/Co/eWs=";
  };

  vendorHash = "sha256-1JAGkrzW2RzGK47Y/YMbXclJqCkbGK8XJEimbg8ETL8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Command-line tool that continuously monitors certificate transparency (CT) logs for newly issued SSL/TLS certificates";
    homepage = "https://github.com/g0ldencybersec/gungnir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cherrykitten ];
    mainProgram = "gungnir";
  };
})
