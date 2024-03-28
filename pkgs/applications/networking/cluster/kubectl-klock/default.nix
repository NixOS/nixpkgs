{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.6.0";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q52YN7IWMvUTtDY5Q0jW5EAyEEB4ebxotgor/HNz/Tg=";
  };

  vendorHash = "sha256-WiKfridBIKhd/UI0byYaCtMZ7FHAE6NBMLuKJe5SKV4=";

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
