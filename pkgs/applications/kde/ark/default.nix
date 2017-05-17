{
  mkDerivation, lib, config, makeWrapper,

  extra-cmake-modules, kdoctools,

  karchive, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, khtml, kio,
  kservice, kpty, kwidgetsaddons, libarchive, kitemmodels,

  # Archive tools
  p7zip, unzipNLS, zip,

  # Unfree tools
  unfreeEnableUnrar ? false, unrar,
}:

mkDerivation {
  name = "ark";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  propagatedBuildInputs = [
    khtml ki18n kio karchive kconfig kcrash kdbusaddons kiconthemes kservice
    kpty kwidgetsaddons libarchive kitemmodels
  ];
  postFixup =
    let
      PATH =
        lib.makeBinPath
        ([ p7zip unzipNLS zip ] ++ lib.optional unfreeEnableUnrar unrar);
    in ''
      wrapProgram "$out/bin/ark" --prefix PATH: "${PATH}"
    '';
  meta = {
    license = with lib.licenses;
      [ gpl2 lgpl3 ] ++ lib.optional unfreeEnableUnrar unfree;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
