{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "sculpin";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    tag = version;
    hash = "sha256-R+Msb7dZhdgvL+KROb1y5VdIX4rV8FgyeULOJUfTwOU=";
  };

  vendorHash = "sha256-N9UsSgGjRTrY2S2iUCwtQJbFZfvTod4+HkLjm4nXfJ8=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "sculpin";
  };
}
