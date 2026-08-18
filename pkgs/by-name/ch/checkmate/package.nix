{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkmate";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = "checkmate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9RgX0jWXMPRcTz8kGKNHnQLJDiKqVh6ugmgXJapc99Q=";
  };

  vendorHash = "sha256-JJR0+fnERLfUIxyfdb2jlH9xHsyvfyycVazoZ3RE4C8=";

  subPackages = [ "." ];

  meta = {
    description = "Pluggable code security analysis tool";
    mainProgram = "checkmate";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
