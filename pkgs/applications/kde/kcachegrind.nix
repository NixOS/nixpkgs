{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  karchive,
  ki18n,
  kio,
  perl,
  python3,
  php,
  qttools,
  kdbusaddons,
  makeBinaryWrapper,
  graphviz,
}:

mkDerivation {
  pname = "kcachegrind";
  meta = with lib; {
    homepage = "https://apps.kde.org/kcachegrind/";
    description = "Profiler frontend";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ orivej ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeBinaryWrapper
  ];
  buildInputs = [
    karchive
    ki18n
    kio
    perl
    python3
    php
    qttools
    kdbusaddons
  ];
  postInstall = ''
    wrapProgram $out/bin/kcachegrind \
      --suffix PATH : "${lib.makeBinPath [ graphviz ]}"
  '';
}
