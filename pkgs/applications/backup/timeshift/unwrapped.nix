{ lib
, stdenv
, fetchFromGitHub
, gettext
<<<<<<< HEAD
, help2man
, meson
, ninja
, pkg-config
, vala
=======
, pkg-config
, vala
, which
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gtk3
, json-glib
, libgee
, util-linux
, vte
, xapp
}:

stdenv.mkDerivation rec {
  pname = "timeshift";
<<<<<<< HEAD
  version = "23.07.1";
=======
  version = "22.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "timeshift";
    rev = version;
<<<<<<< HEAD
    sha256 = "RnArZTzvH+mdT7zAHTRem8+Z8CFjWVvd3p/HwZC/v+U=";
=======
    sha256 = "yZNERRoNZ1K7BRiAu7sqVQyhghsS/AeZSODMVSm46oY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./timeshift-launcher.patch
  ];

  postPatch = ''
    while IFS="" read -r -d $'\0' FILE; do
      substituteInPlace "$FILE" \
        --replace "/sbin/blkid" "${util-linux}/bin/blkid"
    done < <(find ./src -mindepth 1 -name "*.vala" -type f -print0)
    substituteInPlace ./src/Utility/IconManager.vala \
      --replace "/usr/share" "$out/share"
<<<<<<< HEAD
=======
    substituteInPlace ./src/Core/Main.vala \
      --replace "/etc/timeshift/default.json" "$out/etc/timeshift/default.json" \
      --replace "file_copy(app_conf_path_default, app_conf_path);" "if (!dir_exists(file_parent(app_conf_path))){dir_create(file_parent(app_conf_path));};file_copy(app_conf_path_default, app_conf_path);"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    gettext
<<<<<<< HEAD
    help2man
    meson
    ninja
    pkg-config
    vala
=======
    pkg-config
    vala
    which
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
    vte
    xapp
  ];

<<<<<<< HEAD
=======
  preBuild = ''
    makeFlagsArray+=( \
      "-C" "src" \
      "prefix=$out" \
      "sysconfdir=$out/etc" \
    )
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A system restore tool for Linux";
    longDescription = ''
      TimeShift creates filesystem snapshots using rsync+hardlinks or BTRFS snapshots.
      Snapshots can be restored using TimeShift installed on the system or from Live CD or USB.
    '';
    homepage = "https://github.com/linuxmint/timeshift";
<<<<<<< HEAD
    license = licenses.gpl2Plus;
=======
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
    maintainers = with maintainers; [ ShamrockLee bobby285271 ];
  };
}
