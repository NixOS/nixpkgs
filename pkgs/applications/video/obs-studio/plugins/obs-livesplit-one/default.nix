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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = "obs-livesplit-one";
    rev = "v${version}";
    sha256 = "sha256-aU/orE1k6oGzJGU/gFDk9QzcS2QfgvfAUskS5ghftwM=";
  };

  cargoHash = "sha256-aUtOAzBOdOWJhgS6SFzxbJZgM7skr/JOUzeAh2RJ8Es=";

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

  meta = {
    description = "OBS Studio plugin for adding LiveSplit One as a source";
    homepage = "https://github.com/LiveSplit/obs-livesplit-one";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.Bauke ];
    inherit (obs-studio.meta) platforms;
  };
}
