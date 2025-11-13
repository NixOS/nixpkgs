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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = "obs-livesplit-one";
    rev = "v${version}";
    sha256 = "sha256-ClOvpa8tTR+BQ6tx5ihnfoIJJ7oVAHDllZ7ryzFe5RY=";
  };

  cargoHash = "sha256-sRMFl09AW4VBT0oOIsVsCYdYlXUINnNjThYnySkSK+Q=";

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
    inherit (obs-studio.meta) platforms;
  };
}
