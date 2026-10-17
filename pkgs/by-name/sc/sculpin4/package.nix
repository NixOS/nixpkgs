{
  fetchFromGitHub,
  lib,
  php,
  php85,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "sculpin4";
  version = "4.0.0-alpha3";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    tag = version;
    hash = "sha256-4qydUKqi5sPrYKXScND7XwdFItLlud8/VvMla4UOdm0=";
  };

  php = php85;

  vendorHash = "sha256-LO8UBz1+LWoLd13bjL26Mq0zsxzhaanhES/OrM419iA=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "sculpin";
  };
}
