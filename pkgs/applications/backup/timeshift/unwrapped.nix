{ lib
, stdenv
, fetchFromGitHub
, gettext
, help2man
, meson
, ninja
, pkg-config
, vala
, gtk3
, json-glib
, libgee
, util-linux
, vte
, xapp
}:

stdenv.mkDerivation rec {
  pname = "timeshift";
  version = "24.06.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "timeshift";
    rev = version;
    hash = "sha256-H4PCZ1WwNg34WSDXgmH6pUPBglXafLTFfIzvmWiyeCw=";
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
  '';

  nativeBuildInputs = [
    gettext
    help2man
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
    vte
    xapp
  ];

  meta = with lib; {
    description = "A system restore tool for Linux";
    longDescription = ''
      TimeShift creates filesystem snapshots using rsync+hardlinks or BTRFS snapshots.
      Snapshots can be restored using TimeShift installed on the system or from Live CD or USB.
    '';
    homepage = "https://github.com/linuxmint/timeshift";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ShamrockLee bobby285271 ];
  };
}
