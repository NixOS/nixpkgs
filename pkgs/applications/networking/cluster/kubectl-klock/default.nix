{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "jillejr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tXsRifIZRS2W4O4VOONuLsunYGLG5C9KfgnZQQqKACg=";
  };

  vendorSha256 = "sha256-r4oAmD/7CXYiWEWR/FC/Ab0LNxehWv6oCWjQ/fGU2rU=";

  meta = with lib; {
    description = "A kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/jillejr/kubectl-klock";
    changelog = "https://github.com/jillejr/kubectl-klock/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.scm2342 ];
  };
}
