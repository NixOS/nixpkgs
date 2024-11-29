{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "domain_shims";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "gasche";
    repo = "domain-shims";
    rev = version;
    hash = "sha256-/5Cw+M0A1rnT7gFqzryd4Z0tylN0kZgSBXtn9jr8u1c=";
  };

  minimalOCamlVersion = "4.12";

  meta = {
    homepage = "https://gitlab.com/gasche/domain-shims/";
    description = "Non-parallel implementation of Domains compatible with OCaml 4";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
