{ stdenv, fetchFromGitHub, fetchFromGitLab
, autoconf, automake, gettext, intltool
, libtool, pkgconfig, wrapGAppsHook, wrapPython, gobject-introspection
, gtk3, python, pygobject3, pyxdg

, withQuartz ? stdenv.isDarwin, ApplicationServices
, withRandr ? stdenv.isLinux, libxcb
, withDrm ? stdenv.isLinux, libdrm

, withGeolocation ? true
, withCoreLocation ? withGeolocation && stdenv.isDarwin, CoreLocation, Foundation, Cocoa
, withGeoclue ? withGeolocation && stdenv.isLinux, geoclue
, withAppIndicator ? true, libappindicator
}:

let
  mkRedshift =
    { pname, version, src, meta }:
    stdenv.mkDerivation rec {
      inherit pname version src meta;

      patches = stdenv.lib.optionals (pname != "gammastep") [
        # https://github.com/jonls/redshift/pull/575
        ./575.patch
      ];

      postPatch = stdenv.lib.optionalString (pname == "gammastep") ''
        substituteInPlace configure.ac \
          --replace "[gammastep], [2.0]" "[gammastep], [${version}]"
      '';

      nativeBuildInputs = [
        autoconf
        automake
        gettext
        intltool
        libtool
        pkgconfig
        wrapGAppsHook
        wrapPython
      ];

      configureFlags = [
        "--enable-randr=${if withRandr then "yes" else "no"}"
        "--enable-geoclue2=${if withGeoclue then "yes" else "no"}"
        "--enable-drm=${if withDrm then "yes" else "no"}"
        "--enable-quartz=${if withQuartz then "yes" else "no"}"
        "--enable-corelocation=${if withCoreLocation then "yes" else "no"}"
      ];

      buildInputs = [
        gobject-introspection
        gtk3
        python
      ] ++ stdenv.lib.optional  withRandr        libxcb
        ++ stdenv.lib.optional  withGeoclue      geoclue
        ++ stdenv.lib.optional  withDrm          libdrm
        ++ stdenv.lib.optional  withQuartz       ApplicationServices
        ++ stdenv.lib.optionals withCoreLocation [ CoreLocation Foundation Cocoa ]
        ++ stdenv.lib.optional  withAppIndicator libappindicator
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

    meta = with stdenv.lib; {
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
    version = "2.0.1";

    src = fetchFromGitLab {
      owner = "chinstrap";
      repo = pname;
      rev = "v${version}";
      sha256 = "1ky4h892sg2mfbwwq5xv0vnjflsl2x3nsy5q456r1kyk1gwkj0rg";
    };

    meta = redshift.meta // {
      name = "${pname}-${version}";
      longDescription = "Gammastep"
        + stdenv.lib.removePrefix "Redshift" redshift.meta.longDescription;
      homepage = "https://gitlab.com/chinstrap/gammastep";
      maintainers = [ stdenv.lib.maintainers.primeos ] ++ redshift.meta.maintainers;
    };
  };
}
