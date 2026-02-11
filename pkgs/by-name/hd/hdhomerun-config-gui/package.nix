{
  lib,
  stdenv,
  fetchurl,
  libhdhomerun,
  pkg-config,
  gtk2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdhomerun-config-gui";
  version = "20250506";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/hdhomerun_config_gui_${finalAttrs.version}.tgz";
    sha256 = "sha256-bmAdPR5r2mKCncQSSHZ6GYtAk3scHpatnmXGy+a/654=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    libhdhomerun
  ];

  configureFlags = [ "CPPFLAGS=-I${libhdhomerun}/include/hdhomerun" ];
  makeFlags = [ "SUBDIRS=src" ];

  installPhase = ''
    runHook preInstall
    install -vDm 755 src/hdhomerun_config_gui $out/bin/hdhomerun_config_gui
    runHook postInstall
  '';

  meta = {
    description = "GUI for configuring Silicondust HDHomeRun TV tuners";
    homepage = "https://www.silicondust.com/support/linux";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.louisdk1 ];
    mainProgram = "hdhomerun_config_gui";
  };
})
