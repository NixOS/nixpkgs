{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "prox";
  # While upstream did release a v1.0.0, v0.5.2 is actually newer: https://github.com/fgrosse/prox/releases/tag/v0.5.2
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "fgrosse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mqx8ICne0NnyW0N1Jeu+PJXWDBr12OASLxlePI6v6Bc=";
  };

  vendorHash = "sha256-4gZfEbyAzAzxtOR6FhP7eUSdln+fANn87+duCq1aq5A=";

  postPatch = ''
    substituteInPlace cmd/prox/version.go \
      --replace '0.0.0-unknown' '${version}'
  '';

  meta = with lib; {
    homepage = "https://github.com/fgrosse/prox";
    description = "Process runner for Procfile-based applications";
    mainProgram = "prox";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lucperkins ];
  };
}
