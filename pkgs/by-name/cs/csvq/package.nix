{ buildGoModule, fetchFromGitHub, testers, lib, csvq }:

buildGoModule rec {
  pname = "csvq";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "mithrandie";
    repo = "csvq";
    rev = "v${version}";
    hash = "sha256-1UK+LSMKryoUf2UWbGt8MU3zs5hH2WdpA2v/jBaIHYE=";
  };

  vendorHash = "sha256-byBYp+iNnnsAXR+T3XmdwaeeBG8oB1EgNkDabzgUC98=";

  passthru.tests.version = testers.testVersion {
    package = csvq;
    version = "csvq version ${version}";
  };

  meta = with lib; {
    description = "SQL-like query language for CSV";
    mainProgram = "csvq";
    homepage = "https://mithrandie.github.io/csvq/";
    changelog = "https://github.com/mithrandie/csvq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
