{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, makeWrapper,
  kcmutils, kcompletion, kconfig, kdnssd, knotifyconfig, kwallet, kwidgetsaddons,
  kwindowsystem, libvncserver, freerdp
}:

mkDerivation {
  name = "krdc";
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
    license = with licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
