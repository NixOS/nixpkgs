{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, makeWrapper,
  kcmutils, kcompletion, kconfig, kdnssd, knotifyconfig, kwallet, kwidgetsaddons,
  kwindowsystem, libvncserver, freerdp,
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
    mainProgram = "krdc";
    license = with licenses; [ gpl2Plus lgpl21Plus fdl12Plus bsd3 ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
