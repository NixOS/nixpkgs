{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "i3-auto-layout";
  version = "unstable-2022-05-29";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "9e41eb3891991c35b7d35c9558e788899519a983";
    sha256 = "sha256-gpVYVyh+2y4Tttvw1SuCf7mx/nxR330Ob2R4UmHZSJs=";
  };

  cargoHash = "sha256-OxQ7S+Sqc3aRH53Bs53Y+EKOYFgboGOBsQ7KJgICcGo=";

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Automatic, optimal tiling for i3wm";
    mainProgram = "i3-auto-layout";
    homepage = "https://github.com/chmln/i3-auto-layout";
    license = licenses.mit;
    maintainers = with maintainers; [ mephistophiles perstark ];
    platforms = platforms.linux;
  };
}
