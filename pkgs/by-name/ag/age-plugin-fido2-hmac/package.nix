{ lib
, buildGoModule
, fetchFromGitHub
, libfido2
, stdenv
}:

buildGoModule rec {
  pname = "age-plugin-fido2-hmac";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-fido2-hmac";
    rev = "v${version}";
    hash = "sha256-P2gNOZeuODWEb/puFe6EA1wW3pc0xgM567qe4FKbFXg=";
  };

  vendorHash = "sha256-h4/tyq9oZt41IfRJmmsLHUpJiPJ7YuFu59ccM7jHsFo=";

  ldflags = [ "-s" "-w" ];

  buildInputs = [
    libfido2
  ];

  meta = with lib; {
    description = "Age plugin to encrypt files with fido2 tokens using the hmac-secret extension and non-discoverable credentials";
    homepage = "https://github.com/olastor/age-plugin-fido2-hmac/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "age-plugin-fido2-hmac";
    broken = stdenv.isDarwin;
  };
}
