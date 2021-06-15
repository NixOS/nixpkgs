{ lib, fetchgit, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "bombadillo";
  version = "2.3.3";

  src = fetchgit {
    url = "https://tildegit.org/sloum/bombadillo.git";
    rev = version;
    sha256 = "02w6h44sxzmk3bkdidl8xla0i9rwwpdqljnvcbydx5kyixycmg0q";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = null;

  outputs = [ "out" "man" ];

  postInstall = ''
    installManPage bombadillo.1
  '';

  meta = with lib; {
    description = "Non-web client for the terminal, supporting Gopher, Gemini and more";
    homepage = "https://bombadillo.colorfield.space/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ehmry ];
  };
}
