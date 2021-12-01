{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform, scdoc }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-09-30";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "b543d435b92498b72609a05048bc368837a7b455";
    sha256 = "sha256-+SjdhSRT6TGbwvgZti8t9wYJx8LEtY3pleDZx/AEkio=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
  };

  cargoSha256 = "sha256-W7rq42Pz+l4TSsR/h2teRTbl3A1zjOcIx6wqgnwyQNA=";

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
