{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkgconfig
, pantheon
, python3
, substituteAll
, glib
, gtk3
, dosfstools
, e2fsprogs
, exfat
, hfsprogs
, ntfs3g
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "formatter";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Djaler";
    repo = "Formatter";
    rev = version;
    sha256 = "1ghxd2h0pklhlrjslfr46vza1kjsm3mr0sdzzjiqi9jd6hddnk7i";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      ext4 = "${e2fsprogs}/bin/mkfs.ext4";
      exfat = "${exfat}/bin/mkfs.exfat";
      fat = "${dosfstools}/bin/mkfs.fat";
      ntfs = "${ntfs3g}/bin/mkfs.ntfs";
      hfsplus = "${hfsprogs}/bin/mkfs.hfsplus";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple formatter designed for elementary OS";
    homepage = "https://github.com/Djaler/Formatter";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
