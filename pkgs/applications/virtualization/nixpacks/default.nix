{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Rt65BXrDFne7bT26yQLVMNwwgN8JAmXLrGx/BLlInkI=";
  };

  cargoHash = "sha256-dZbLLxvkJzApl9+MwbZRJQXFzMHOfbikwEZs9wFKZHQ=";
=======
    sha256 = "sha256-iz/lTm/8Oqmo16lMDxpI2vFFq6BnnG2yeDAgKc8jTFU=";
  };

  cargoHash = "sha256-/V4Zj9yJtl3Fo7vXc0f3J6cp/mSxFG9YJg1r/RoHx/M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
