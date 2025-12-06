{
  lib,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "starship-jj";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oisz3V3UDHvmvbA7+t5j7waN9NykMUWGOpEB5EkmYew=";
  };

  cargoHash = "sha256-NNeovW27YSK/fO2DjAsJqBvebd43usCw7ni47cgTth8=";

  meta = with lib; {
    description = "Starship plugin for jj";
    homepage = "https://gitlab.com/lanastara_foss/starship-jj";
    maintainers = with maintainers; [
      nemith
    ];
    license = licenses.mit;
  };
}
