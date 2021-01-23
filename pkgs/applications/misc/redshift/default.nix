{ lib, stdenv, fetchFromGitHub, fetchFromGitLab
, autoconf, automake, gettext, intltool
, libtool, pkg-config, wrapGAppsHook, wrapPython, gobject-introspection
, gtk3, python, pygobject3, pyxdg

, withQuartz ? stdenv.isDarwin, ApplicationServices
, withRandr ? stdenv.isLinux, libxcb
, withDrm ? stdenv.isLinux, libdrm

, withGeolocation ? true
, withCoreLocation ? withGeolocation && stdenv.isDarwin, CoreLocation, Foundation, Cocoa
, withGeoclue ? withGeolocation && stdenv.isLinux, geoclue
, withAppIndicator ? stdenv.isLinux, libappindicator, libayatana-appindicator
}:

let
  mkRedshift =
    { pname, version, src, meta }:
    stdenv.mkDerivation rec {
      inherit pname version src meta;

      patches = lib.optionals (pname != "gammastep") [
        # https://github.com/jonls/redshift/pull/575
        ./575.patch
      ];

      nativeBuildInputs = [
        autoconf
        automake
        gettext
        intltool
        libtool
        pkg-config
        wrapGAppsHook
        wrapPython
      ];

      configureFlags = [
        "--enable-randr=${if withRandr then "yes" else "no"}"
        "--enable-geoclue2=${if withGeoclue then "yes" else "no"}"
        "--enable-drm=${if withDrm then "yes" else "no"}"
        "--enable-quartz=${if withQuartz then "yes" else "no"}"
        "--enable-corelocation=${if withCoreLocation then "yes" else "no"}"
      ] ++ lib.optionals (pname == "gammastep") [
        "--with-systemduserunitdir=${placeholder "out"}/share/systemd/user/"
        "--enable-apparmor"
      ];

      buildInputs = [
        gobject-introspection
        gtk3
        python
      ] ++ lib.optional  withRandr        libxcb
        ++ lib.optional  withGeoclue      geoclue
        ++ lib.optional  withDrm          libdrm
        ++ lib.optional  withQuartz       ApplicationServices
        ++ lib.optionals withCoreLocation [ CoreLocation Foundation Cocoa ]
        ++ lib.optional  withAppIndicator (if (pname != "gammastep")
             then libappindicator
             else libayatana-appindicator)
        ;

      pythonPath = [ pygobject3 pyxdg ];

      preConfigure = "./bootstrap";

      postFixup = "wrapPythonPrograms";

      # the geoclue agent may inspect these paths and expect them to be
      # valid without having the correct $PATH set
      postInstall = if (pname == "gammastep") then ''
        substituteInPlace $out/share/applications/gammastep.desktop \
          --replace 'Exec=gammastep' "Exec=$out/bin/gammastep"
        substituteInPlace $out/share/applications/gammastep-indicator.desktop \
          --replace 'Exec=gammastep-indicator' "Exec=$out/bin/gammastep-indicator"
      '' else ''
        substituteInPlace $out/share/applications/redshift.desktop \
          --replace 'Exec=redshift' "Exec=$out/bin/redshift"
        substituteInPlace $out/share/applications/redshift-gtk.desktop \
          --replace 'Exec=redshift-gtk' "Exec=$out/bin/redshift-gtk"
      '';

      enableParallelBuilding = true;
    };
in
rec {
  redshift = mkRedshift rec {
    pname = "redshift";
    version = "1.12";

    src = fetchFromGitHub {
      owner = "jonls";
      repo = "redshift";
      rev = "v${version}";
      sha256 = "12cb4gaqkybp4bkkns8pam378izr2mwhr2iy04wkprs2v92j7bz6";
    };

    meta = with lib; {
      description = "Screen color temperature manager";
      longDescription = ''
        Redshift adjusts the color temperature according to the position
        of the sun. A different color temperature is set during night and
        daytime. During twilight and early morning, the color temperature
        transitions smoothly from night to daytime temperature to allow
        your eyes to slowly adapt. At night the color temperature should
        be set to match the lamps in your room.
      '';
      license = licenses.gpl3Plus;
      homepage = "http://jonls.dk/redshift";
      platforms = platforms.unix;
      maintainers = with maintainers; [ yegortimoshenko globin ];
    };
  };

  redshift-wlr = mkRedshift {
    pname = "redshift-wlr";
    # upstream rebases so this is the push date
    version = "2019-08-24";

    src = fetchFromGitHub {
      owner = "minus7";
      repo = "redshift";
      rev = "7da875d34854a6a34612d5ce4bd8718c32bec804";
      sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };

    meta = redshift.meta // {
      description = redshift.meta.description + "(with wlroots patches)";
      homepage = "https://github.com/minus7/redshift";
    };
  };

  gammastep = mkRedshift rec {
    pname = "gammastep";
    version = "2.0.7";

    src = fetchFromGitLab {
      owner = "chinstrap";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-78z2CQ+r7undbp+8E0mMDNWWl+RXeS5he/ax0VomRYY=";
    };

    meta = redshift.meta // {
      name = "${pname}-${version}";
      longDescription = "Gammastep"
        + lib.removePrefix "Redshift" redshift.meta.longDescription;
      homepage = "https://gitlab.com/chinstrap/gammastep";
      maintainers = [ lib.maintainers.primeos ] ++ redshift.meta.maintainers;
    };
  };
}
