{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.5.1";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q7Wq1mTjOB7tT66+LWIwwqltQcQSHD/VHLO7nCTZTQ0=";
  };

  vendorHash = "sha256-3CJ/tmFFkmq6wHxbqk8u+GxxbSrUpB/JD5s/S7hegB8=";

  postInstall = ''
    makeWrapper $out/bin/kubectl-klock $out/bin/kubectl_complete-klock --add-flags __complete
  '';

  meta = with lib; {
    description = "A kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/applejag/kubectl-klock";
    changelog = "https://github.com/applejag/kubectl-klock/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.scm2342 ];
  };
}
