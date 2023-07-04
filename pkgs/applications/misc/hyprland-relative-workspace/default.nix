{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-relative-workspace";
  version = "1.1.8-unstable-2023-04-25";

  src = fetchFromGitHub {
    owner = "CheesyPhoenix";
    repo = pname;
    rev = "708e9bf22f100a33948d7ab10bee390b2a454ff8";
    sha256 = "sha256-PN3t3sVIFz1dKVtBEFLmPO9YAhXpbWcT5uurkNqtFqc=";
  };

  cargoSha256 = "sha256-Jh8eXkj7109z9Sdk97Dy0Hsh5ulSgTrQVRYBvKq/P+I=";

  meta = with lib; {
    description = "GNOME-like workspace switching in Hyprland";
    homepage = "https://github.com/CheesyPhoenix/hyprland-relative-workspace";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
  };
}
