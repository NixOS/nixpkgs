{ lib, elixir
, beamPackages
, fetchFromGitHub
, nix-update-script
}:

beamPackages.mixRelease rec {
  pname = "keila";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "pentacent";
    repo = "keila";
    rev = "v${version}";
    sha256 = "sha256-CHl6PEbEjXVZ1h5zAjM76mkAJ0L8a95iIcRhzb9WIxc=";
  };

  mixNixDeps = import ./mix_deps.nix {
    inherit beamPackages lib;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open Source alternative to newsletter tools like Mailchimp or Sendinblue";
    homepage = "https://keila.io";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ dvn0 ];
  };
}
