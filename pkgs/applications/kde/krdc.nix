{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  makeWrapper,
  kcmutils,
  kcompletion,
  kconfig,
  kdnssd,
  knotifyconfig,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  libvncserver,
  freerdp,
}:

mkDerivation {
  pname = "krdc";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeWrapper
  ];
  buildInputs = [
    kcmutils
    kcompletion
    kconfig
    kdnssd
    knotifyconfig
    kwallet
    kwidgetsaddons
    kwindowsystem
    freerdp
    libvncserver
  ];
  postFixup = ''
    wrapProgram $out/bin/krdc \
      --prefix PATH : ${lib.makeBinPath [ freerdp ]}
  '';
  meta = {
    homepage = "http://www.kde.org";
    description = "Remote desktop client";
    mainProgram = "krdc";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
}
