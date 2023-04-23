{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, cyrus_sasl, kcmutils,
  ki18n, kio, kmime, kwallet, ksmtp, libkgapi,
  kcalendarcore, kcontacts, qtkeychain, libsecret
}:

mkDerivation {
  pname = "kmailtransport";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi kcmutils ki18n kio ksmtp libkgapi kcalendarcore kcontacts
    qtkeychain libsecret
  ];
  propagatedBuildInputs = [ akonadi-mime cyrus_sasl kmime kwallet ];
  outputs = [ "out" "dev" ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
