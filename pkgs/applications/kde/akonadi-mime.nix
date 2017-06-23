{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, shared_mime_info,
  akonadi, kdbusaddons, ki18n, kio, kitemmodels, kmime
}:

mkDerivation {
  name = "akonadi-mime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules shared_mime_info ];
  buildInputs = [ akonadi kdbusaddons ki18n kio kitemmodels kmime ];
  outputs = [ "out" "dev" ];
}
