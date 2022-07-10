{ lib
, stdenv
, fetchFromGitHub
, gettext
, pkg-config
, vala
, which
, gtk3
, json-glib
, libgee
, util-linux
, vte
, xapps
}:

stdenv.mkDerivation rec {
  pname = "timeshift";
  version = "22.06.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "timeshift";
    rev = "v${version}";
    sha256 = "XcxwVBKMv2YwbrI3FFWDQFs8hHruhkZq3YqzkptE6KE=";
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
    substituteInPlace ./src/Core/Main.vala \
      --replace "/etc/timeshift/default.json" "$out/etc/timeshift/default.json" \
      --replace "file_copy(app_conf_path_default, app_conf_path);" "if (!dir_exists(file_parent(app_conf_path))){dir_create(file_parent(app_conf_path));};file_copy(app_conf_path_default, app_conf_path);"
  '';

  nativeBuildInputs = [
    gettext
    pkg-config
    vala
    which
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
    vte
    xapps
  ];

  preBuild = ''
    makeFlagsArray+=( \
      "-C" "src" \
      "prefix=$out" \
      "sysconfdir=$out/etc" \
    )
  '';

  meta = with lib; {
    description = "A system restore tool for Linux";
    longDescription = ''
      TimeShift creates filesystem snapshots using rsync+hardlinks or BTRFS snapshots.
      Snapshots can be restored using TimeShift installed on the system or from Live CD or USB.
    '';
    homepage = "https://github.com/linuxmint/timeshift";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
