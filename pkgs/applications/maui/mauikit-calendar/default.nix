{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, mauikit
, qtquickcontrols2
, akonadi
, akonadi-contacts
, akonadi-calendar
, calendarsupport
, eventviews
}:

mkDerivation {
  pname = "mauikit-calendar";

<<<<<<< HEAD
=======
  patches = [ ./add-akonadi-calendar.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    akonadi
    akonadi-contacts
    akonadi-calendar
    calendarsupport
    eventviews
    mauikit
    qtquickcontrols2
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-calendar";
    description = "Calendar support components for Maui applications";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ onny ];
  };
}
