{ lib, buildGo121Module, fetchFromGitHub }:

buildGo121Module rec {
  pname = "kubectl-klock";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jillejr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HO9/hr/CBmJkrbNdX8tp2pNRfZDaWNW8shyCR46G77A=";
  };

  vendorHash = "sha256-QvD5yVaisq5Zz/M81HAMKpgQJRB5qPCYveLgldHHGf0=";

  meta = with lib; {
    description = "A kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/jillejr/kubectl-klock";
    changelog = "https://github.com/jillejr/kubectl-klock/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.scm2342 ];
  };
}
