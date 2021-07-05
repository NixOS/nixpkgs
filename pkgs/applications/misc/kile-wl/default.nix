{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform, scdoc }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-06-24";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "6a306b0b5af0f250135eb88e0e72a5038fccd6a8";
    sha256 = "sha256-DznIDzI5rNrlKJdXjpOpsLL8IO6tuIvW0pNdRN8N6Go=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
  };

  cargoSha256 = "sha256-LFRqhgvziQ7a8OWRzXqNIfziP6bRHTe2oF55N09rFy8=";

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
