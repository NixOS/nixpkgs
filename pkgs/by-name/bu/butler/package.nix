{
  buildGoModule,
  brotli,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "butler";
  version = "15.26.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FaYxvqC/ZYFukh6H63A0dx/8IkSM0Awf4JDBZgvc5W4=";
  };

  buildInputs = [ brotli ];

  doCheck = false; # disabled because the tests don't work in a non-FHS compliant environment.

  vendorHash = "sha256-8f4EVARMtdzXL3YxGimgLM/A7BF/GOaEoxffkQ1SlHw=";

  meta = {
    description = "Command-line itch.io helper";
    changelog = "https://github.com/itchio/butler/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "http://itch.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naelstrof ];
  };
})
