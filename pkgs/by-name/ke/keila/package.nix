{ lib, beamPackages
, fetchFromGitHub
}:

beamPackages.mixRelease rec {
  pname = "keila";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "pentacent";
    repo = "keila";
    rev = "v${version}";
    sha256 = "sha256-HyRHzxbFmVM3/fIIaB2aLBG7pKsQ8+QocGkZVtodwVc=";
  };

  mixNixDeps = import ./mix_deps.nix {
    inherit beamPackages lib;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open Source alternative to newsletter tools like Mailchimp or Sendinblue";
    homepage = "https://keila.io";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ dvn0 ];
  };
}
