{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {

  pname = "fire-cli";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "horizonwiki";
    repo = "fire";
    rev = version;
    hash = "sha256-0GCB4umlxmENKNGUmNI7rssCI1Pk6IgmyHEKp/if2xA=";

  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "Terminal fire animation written in Rust";
    homepage = "https://github.com/horizonwiki/fire";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ horizonwiki ];
    mainProgram = "fire"; 
  };
}
