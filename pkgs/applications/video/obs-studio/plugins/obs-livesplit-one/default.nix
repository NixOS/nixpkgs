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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = "obs-livesplit-one";
    rev = "v${version}";
    sha256 = "sha256-4Ar4ChSl226BVFyAnqpWDLxsZF63bxl++sWD+6aENW8=";
  };

  cargoHash = "sha256-e0FDa72vzRb5AMVmtkvAkiQ5GUXsq0LekqF+wDYDsr8=";

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
