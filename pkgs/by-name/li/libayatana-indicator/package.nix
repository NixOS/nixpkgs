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

stdenv.mkDerivation (finalAttrs: {
  pname = "libayatana-indicator";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-indicator";
    rev = finalAttrs.version;
    sha256 = "sha256-1fdISeo9854CBNfgE9/ihnqS0ozb5LGw9XKxwKx0xCI=";
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
    changelog = "https://github.com/AyatanaIndicators/libayatana-indicator/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nickhu ];
    platforms = lib.platforms.linux;
  };
})
