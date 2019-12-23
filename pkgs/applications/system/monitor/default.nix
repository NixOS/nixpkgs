{ stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, vala
, pkg-config
, pantheon
, python3
, gettext
, glib
, gtk3
, bamf
, libwnck3
, libgee
, libgtop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "monitor";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "stsdc";
    repo = "monitor";
    rev = version;
    sha256 = "17z1m193s7qygavfwd8qsw97blxbfmq9gnsymdjlc1ddk8hldw0z";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    glib
    gtk3
    pantheon.granite
    pantheon.wingpanel
    libgee
    libgtop
    libwnck3
  ];

   patches =  [
     (fetchpatch {
       name = "07d1984175fcaef2909029a387f830efd647471b.patch";
       url = "https://github.com/stsdc/monitor/commit/07d1984175fcaef2909029a387f830efd647471b.patch";
       sha256 = "0nrfsg8k6spcgk1aw227vgyvz73xfl49yck7gm0id6aj180bmcx8";
     })
     (fetchpatch {
       name = "ab2cfed150cd2a6b5c3fcee5297a65c1b429c674.patch";
       url = "https://github.com/stsdc/monitor/commit/ab2cfed150cd2a6b5c3fcee5297a65c1b429c674.patch";
       sha256 = "1imzsir654symx646w1w1nm2zaq3z4sn6c9hak9n54ziwa7wn171";
     })
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
    description = "Manage processes and monitor system resources";
    homepage = "https://github.com/stsdc/monitor";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
