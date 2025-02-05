{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  fontconfig,
  obs-studio,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-livesplit-one";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3B3P1PlzIlpVqHJMKWpEnWXGgD/IaiWM1FVKn0BtRj0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "livesplit-auto-splitting-0.1.0" = "sha256-/xQEVJH6m6nH5Z1kuOPEElOcOqJmiG9Q8cOx0e6p3Wc=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    fontconfig
    obs-studio
  ];

  postInstall = ''
    mkdir $out/lib/obs-plugins/
    mv $out/lib/libobs_livesplit_one.so $out/lib/obs-plugins/obs-livesplit-one.so
  '';

  meta = with lib; {
    description = "OBS Studio plugin for adding LiveSplit One as a source";
    homepage = "https://github.com/LiveSplit/obs-livesplit-one";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ maintainers.Bauke ];
    platforms = obs-studio.meta.platforms;
  };
}
