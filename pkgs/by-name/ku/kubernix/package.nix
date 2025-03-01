{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubernix";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = pname;
    rev = "v${version}";
    sha256 = "04dzfdzjwcwwaw9min322g30q0saxpq5kqzld4f22fmk820ki6gp";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clap-3.0.0-beta.1" = "sha256-tErZmEiAF1v39AtgRUHoEmoYqXPWRDXBEkWUbH+fPyY=";
      "clap_derive-0.3.0" = "sha256-VijH+XB4WeKYUsJH9h/ID8EGZ89R3oauYO8Yg331dPU=";
    };
  };
  doCheck = false;

  meta = with lib; {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    mainProgram = "kubernix";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
  };
}
