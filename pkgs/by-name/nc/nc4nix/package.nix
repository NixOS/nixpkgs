{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "nc4nix";
  version = "0-unstable-2024-03-01";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "ba37674c0dddf93e0a011dace92ec7f0ec834765";
    hash = "sha256-k12eeP2gojLCsJH1GGuiTmxz3ViPc0+oFBuptyh42Bw=";
  };

  vendorHash = "sha256-ZXl4kMDY9ADkHUcLsl3uNpyErMzbgS+J65+uUeIXpSE=";

  meta = with lib; {
    description = "Packaging helper for Nextcloud apps";
    mainProgram = "nc4nix";
    homepage = "https://github.com/helsinki-systems/nc4nix";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

