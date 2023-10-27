{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "prox";
  # While upstream did release a v1.0.0, v1.0.0 is actually newer: https://github.com/fgrosse/prox/releases/tag/v1.0.0
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fgrosse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4lonUeF77KVeLZFxxMJcvKobrVtbFEDJRWj/SsmQFAs=";
  };

  vendorHash = "sha256-f0fKW9ydDfF7UxzeD4ZGM0SJLo7RQNMAnI8Vocr1vK4=";

  postPatch = ''
    substituteInPlace cmd/prox/version.go \
      --replace '0.0.0-unknown' '${version}'
  '';

  meta = with lib; {
    homepage = "https://github.com/fgrosse/prox";
    description = "A process runner for Procfile-based applications ";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lucperkins ];
  };
}
