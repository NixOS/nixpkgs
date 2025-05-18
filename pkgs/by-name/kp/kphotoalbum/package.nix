{
  stdenv,
  fetchurl,
  lib,
  extra-cmake-modules,
  exiv2,
  ffmpeg,
  libvlc,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kphotoalbum";
  version = "6.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/kphotoalbum/${finalAttrs.version}/kphotoalbum-${finalAttrs.version}.tar.xz";
    hash = "sha256-LLsQ66wKDg77nZUIxjcfzvC3AwLOtojuuDgkJm2dsww=";
  };

  env.LANG = "C.UTF-8";

  buildInputs = [
    kdePackages.qtbase
    exiv2
    libvlc
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  # not sure if we really need phonon when we have vlc, but on KDE it's bound to
  # be on the system anyway, so there is no real harm including it
  propagatedBuildInputs = with kdePackages; [
    kconfig
    kiconthemes
    kio
    kxmlgui
    phonon
    purpose
    libkdcraw
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  meta = with lib; {
    description = "Efficient image organization and indexing";
    homepage = "https://www.kphotoalbum.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kdePackages.kconfig.meta) platforms;
  };
})
