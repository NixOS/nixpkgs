{
  mkDerivation, lib,
  extra-cmake-modules,
  akonadi, kdbusaddons, ki18n, kio, kitemmodels, kmime,
  shared_mime_info
}:

mkDerivation {
  name = "akonadi-mime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ akonadi shared_mime_info
                  kdbusaddons ki18n kio kitemmodels kmime ];
  outputs = [ "out" "dev" ];
}
