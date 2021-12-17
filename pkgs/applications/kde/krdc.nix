{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, makeWrapper,
  kcmutils, kcompletion, kconfig, kdnssd, knotifyconfig, kwallet, kwidgetsaddons,
  kwindowsystem, libvncserver, freerdp, qtbase,
}:

mkDerivation {
  pname = "krdc";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  buildInputs = [
    kcmutils kcompletion kconfig kdnssd knotifyconfig kwallet kwidgetsaddons
    kwindowsystem freerdp libvncserver
  ];
  postFixup = ''
    wrapProgram $out/bin/krdc \
      --prefix PATH : ${lib.makeBinPath [ freerdp ]}
  '';
  meta = with lib; {
    homepage = "http://www.kde.org";
    description = "Remote desktop client";
    license = with licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    broken = lib.versionOlder qtbase.version "5.14";
  };
}
