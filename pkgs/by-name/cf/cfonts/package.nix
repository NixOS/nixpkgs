{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ixxDlHjx5Bi6Wl/kzJ/R7d+jgTDCAti25TV1RlXRPus=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eJM3CS3I++p6Pk/K8vkD/H/RAmD+eQJ+//It/Jn5dX4=";

  meta = with lib; {
    homepage = "https://github.com/dominikwilkowski/cfonts";
    description = "A silly little command line tool for sexy ANSI fonts in the console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leifhelm ];
    mainProgram = "cfonts";
  };
}
