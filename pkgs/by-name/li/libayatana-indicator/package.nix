{
  ayatana-ido,
  cmake,
  fetchFromGitHub,
  glib,
  gtk3,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libayatana-indicator";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-indicator";
    rev = version;
    sha256 = "sha256-OsguZ+jl274uPSCTFHq/ZwUE3yHR7MlUPHCpfmn1F7A=";
  };

  nativeBuildInputs = [
    cmake
    glib # for glib-mkenums
    pkg-config
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ ayatana-ido ];

  strictDeps = true;

  meta = {
    description = "Ayatana Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-indicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-indicator/blob/${version}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nickhu ];
    platforms = lib.platforms.linux;
  };
}
