{ fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "nixos-needsreboot";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "thefossguy";
    repo = "nixos-needsreboot";
    rev = version;
    hash = "sha256-0MpqqkkpTMiq5xgzSOqBZMLUfVhtfEfRXWZzt2tqRKI=";
  };

  cargoHash = "sha256-LzO1kkrpWTjLnqs0HH5AIFLOZxtg0kUDIqXCVKSqsAc=";

  meta = with lib; {
    description = "Determine if you need to reboot your NixOS machine";
    homepage = "https://github.com/thefossguy/nixos-needsreboot";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ thefossguy ];
    mainProgram = "nixos-needsreboot";
  };
}
