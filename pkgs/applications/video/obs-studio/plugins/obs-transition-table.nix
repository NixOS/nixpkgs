{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation {
  pname = "obs-transition-table";
  version = "0.2.7-unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-transition-table";
    rev = "976fe236dac7082b6c953f950fcb9e50495ce624";
    sha256 = "sha256-TPRqKjEXdvjv+RfHTaeeO4GHur2j/+onehcu0I/HdD0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to add a Transition Table to the tools menu";
    homepage = "https://github.com/exeldro/obs-transition-table";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
