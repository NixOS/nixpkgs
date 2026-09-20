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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = "obs-livesplit-one";
    rev = "v${version}";
    sha256 = "sha256-yK2o3W2rwalPbmPOiB4M6tuBBSxl9ztaWqvUqeoTqVg=";
  };

  cargoHash = "sha256-a3G/3R+Y5EPf0Gf40U2/Iehbqvsf6KzD2Vv/zqF/h/k=";

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
