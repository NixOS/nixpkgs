{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform, scdoc }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-09-02";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "acd61f7e59cc34091c976b0cdc3067dd35b53cae";
    sha256 = "sha256-O5sdPw9tR3GFPmJmb/QDmdBc7yeSGui4k+yn4Xo016A=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
  };

  cargoSha256 = "sha256-2QCv5fk0AH4sv0QJ/16zniHfg3HZLoHB7dl6vSfkxpE=";

  nativeBuildInputs = [ scdoc ];

  postInstall = ''
    mkdir -p $out/share/man
    scdoc < doc/kile.1.scd > $out/share/man/kile.1
  '';

  meta = with lib; {
    description = "A tiling layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    platforms = platforms.linux; # It's meant for river, a wayland compositor
    maintainers = with maintainers; [ fortuneteller2k ];
    mainProgram = "kile";
  };
}
