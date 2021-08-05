{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform, scdoc }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-08-03";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "7f0b1578352d935084d3d56ef42487d2a8cfbfe8";
    sha256 = "sha256-Ir9LNQt7/7TjhCJ69HYx1tBXeq/i7F3ydmenvchZgDI=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
  };

  cargoSha256 = "sha256-195rPxX3BTxJ0xLgye14aWuBd5OuJ30wyUa4wrbQ3Xo=";

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
