{ stdenv, fetchFromGitHub, autoconf, automake, gettext, intltool
, libtool, pkgconfig, wrapGAppsHook, wrapPython, gobject-introspection
, gtk3, python, pygobject3, pyxdg

, withQuartz ? stdenv.isDarwin, ApplicationServices
, withRandr ? stdenv.isLinux, libxcb
, withDrm ? stdenv.isLinux, libdrm

, withGeolocation ? true
, withCoreLocation ? withGeolocation && stdenv.isDarwin, CoreLocation, Foundation, Cocoa
, withGeoclue ? withGeolocation && stdenv.isLinux, geoclue
}:

let
  mkRedshift =
    { pname, version, src, meta }:
    stdenv.mkDerivation rec {
      inherit pname version src meta;

      patches = [
        # https://github.com/jonls/redshift/pull/575
        ./575.patch
      ];

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
        ;

      pythonPath = [ pygobject3 pyxdg ];

      preConfigure = "./bootstrap";

      postFixup = "wrapPythonPrograms";

      # the geoclue agent may inspect these paths and expect them to be
      # valid without having the correct $PATH set
      postInstall = ''
        substituteInPlace $out/share/applications/redshift.desktop \
          --replace 'Exec=redshift' "Exec=$out/bin/redshift"
        substituteInPlace $out/share/applications/redshift.desktop \
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
      homepage = http://jonls.dk/redshift;
      platforms = platforms.unix;
      maintainers = with maintainers; [ yegortimoshenko globin ];
    };
  };

  redshift-wlr = mkRedshift {
    pname = "redshift-wlr";
    version = "2019-04-17";

    src = fetchFromGitHub {
      owner = "minus7";
      repo = "redshift";
      rev = "eecbfedac48f827e96ad5e151de8f41f6cd3af66";
      sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };

    meta = redshift.meta // {
      description = redshift.meta.description + "(with wlroots patches)";
      homepage = https://github.com/minus7/redshift;
    };
  };
}
