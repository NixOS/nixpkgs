{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "linkstack";
  version = "4.8.4";

  src = fetchFromGitHub {
    owner = "LinkStackOrg";
    repo = "LinkStack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k0YvCUawm79Te/Im+mz8VpNUwNjSBblatTJGWsEvLnI=";
  };

  vendorHash = "sha256-dof4M3Sfnkc1Ms3gZDuqmhWvwzsk7EP9eb0LV7ui+tU=";

  composerStrictValidation = false;

  meta = {
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ j0hax ];
    description = "A customizable link sharing platform";
    homepage = "https://linkstack.org/";
  };
})
