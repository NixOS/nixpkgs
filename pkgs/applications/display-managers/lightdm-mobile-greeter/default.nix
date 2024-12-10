{
  lib,
  fetchFromGitea,
  gtk3,
  libhandy_0,
  lightdm,
  lightdm-mobile-greeter,
  linkFarm,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lightdm-mobile-greeter";
  version = "2022-10-30";

  src = fetchFromGitea {
    domain = "git.raatty.club";
    owner = "raatty";
    repo = "lightdm-mobile-greeter";
    rev = "8c8d6dfce62799307320c8c5a1f0dd5c8c18e4d3";
    hash = "sha256-SrAR2+An3BN/doFl/s8PcYZMUHLfVPXKZOo6ndO60nY=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "light-dm-sys-0.0.1" = "sha256-91MZhbO/Or0QOt0yVAUhtorpMBBzElFg6U59mF7WB0k=";
    };
  };

  buildInputs = [
    gtk3
    libhandy_0
    lightdm
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  postInstall = ''
    mkdir -p $out/share/xgreeters
    substitute lightdm-mobile-greeter.desktop \
      $out/share/xgreeters/lightdm-mobile-greeter.desktop \
      --replace lightdm-mobile-greeter $out/bin/lightdm-mobile-greeter
  '';

  passthru.xgreeters = linkFarm "lightdm-mobile-greeter-xgreeters" [
    {
      path = "${lightdm-mobile-greeter}/share/xgreeters/lightdm-mobile-greeter.desktop";
      name = "lightdm-mobile-greeter.desktop";
    }
  ];

  meta = with lib; {
    description = "A simple log in screen for use on touch screens";
    homepage = "https://git.raatty.club/raatty/lightdm-mobile-greeter";
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
    license = licenses.mit;
    mainProgram = "lightdm-mobile-greeter";
  };
}
