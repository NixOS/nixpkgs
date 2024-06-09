{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.7.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Tsrfan7aejP2oy9x9VoTIq0ba0s0tnx1RTlAB0v6eis=";
  };

  cargoHash = "sha256-jstxl1CcSNv1bQuAY9n2kYmoTYmfeBYUCKJKWCSEuec=";
  nativeBuildInputs = [ installShellFiles ];

  # In case anything goes wrong.
  checkFlags = [ "RUST_BACKTRACE=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  passthru.tests.version = testers.testVersion { package = sigi; };

  meta = with lib; {
    description = "Organizing CLI for people who don't love organizing.";
    homepage = "https://github.com/sigi-cli/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ booniepepper ];
    mainProgram = "sigi";
  };
}
