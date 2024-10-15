{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "puffin";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "siddhantac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F9ZGy7oihCrpGueWANjBYUBgWqaesGdmSb0bhsSSYUQ=";
  };

  vendorHash = "sha256-XfsGXh9nz+QJEAqtw/BfzHhSVje6q0KLsVg1ZQ6fN4U=";

  meta = {
    description = "A beautiful terminal dashboard for hledger";
    homepage = "https://github.com/siddhantac/puffin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renesat ];
  };
}
