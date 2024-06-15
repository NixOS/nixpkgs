{
  mkDerivation, lib,
  extra-cmake-modules,
  karchive, kcrash, ki18n, kio, libgcrypt, qca-qt5, solid,
  boost, gmp
}:

mkDerivation {
  pname = "libktorrent";
  meta = with lib; {
    description = "BitTorrent library used by KTorrent";
    homepage    = "https://apps.kde.org/ktorrent/";
    maintainers = with maintainers; [ eelco ];
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kcrash ki18n kio libgcrypt qca-qt5 solid ];
  propagatedBuildInputs = [ boost gmp ];
  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;
}
