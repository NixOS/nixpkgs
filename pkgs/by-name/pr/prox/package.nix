{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "prox";
  # While upstream did release a v1.0.0, v1.1.0 is actually newer: https://github.com/fgrosse/prox/releases/tag/v1.1.0
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fgrosse";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KSHTlcAmnuU8F17N0LBS0s5b/k6Of0OEHVd3v50bH3g=";
  };

  vendorHash = "sha256-i4QJ84Tne1E8s2Fprd5xeWlTQBIb/9tvwws80yHXhbg=";

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
