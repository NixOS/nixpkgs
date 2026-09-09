{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hcledit";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "hcledit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WELq0vHXMR3gRyO6ALyl+FP11sp919Emm0q2RyGYa7Y=";
  };

  vendorHash = "sha256-ThhZKZRODvjB4ityDFTf77XQVwcICkbKhDH2BEf3nz0=";

  meta = {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
