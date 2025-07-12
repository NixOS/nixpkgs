{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  autoconf,
  automake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  wrapGAppsHook3,
  wrapPython,
  gobject-introspection,
  wayland-scanner,
  gtk3,
  python,
  pygobject3,
  pyxdg,

  withQuartz ? stdenv.hostPlatform.isDarwin,
  withRandr ? stdenv.hostPlatform.isLinux,
  libxcb,
  withDrm ? stdenv.hostPlatform.isLinux,
  libdrm,
  withVidmode ? stdenv.hostPlatform.isLinux,
  libXxf86vm,

  withGeolocation ? true,
  withCoreLocation ? withGeolocation && stdenv.hostPlatform.isDarwin,
  withGeoclue ? withGeolocation && stdenv.hostPlatform.isLinux,
  geoclue,
  withAppIndicator ? stdenv.hostPlatform.isLinux,
  libappindicator,
  libayatana-appindicator,
}:

let
  mkRedshift =
    {
      pname,
      version,
      src,
      meta,
    }:
    stdenv.mkDerivation rec {
      inherit
        pname
        version
        src
        meta
        ;

      patches = lib.optionals (pname != "gammastep") [
        # https://github.com/jonls/redshift/pull/575
        ./575.patch
      ];

      strictDeps = true;

      depsBuildBuild = [ pkg-config ];

      nativeBuildInputs = [
        autoconf
        automake
        gettext
        intltool
        libtool
        pkg-config
        wrapGAppsHook3
        wrapPython
        gobject-introspection
        python
      ] ++ lib.optionals (pname == "gammastep") [ wayland-scanner ];

      configureFlags =
        [
          "--enable-randr=${if withRandr then "yes" else "no"}"
          "--enable-geoclue2=${if withGeoclue then "yes" else "no"}"
          "--enable-drm=${if withDrm then "yes" else "no"}"
          "--enable-vidmode=${if withVidmode then "yes" else "no"}"
          "--enable-quartz=${if withQuartz then "yes" else "no"}"
          "--enable-corelocation=${if withCoreLocation then "yes" else "no"}"
        ]
        ++ lib.optionals (pname == "gammastep") [
          "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user/"
          "--enable-apparmor"
        ];

      buildInputs =
        [
          gtk3
        ]
        ++ lib.optional withRandr libxcb
        ++ lib.optional withGeoclue geoclue
        ++ lib.optional withDrm libdrm
        ++ lib.optional withVidmode libXxf86vm
        ++ lib.optional withAppIndicator (
          if (pname != "gammastep") then libappindicator else libayatana-appindicator
        );

      pythonPath = [
        pygobject3
        pyxdg
      ];

      preConfigure = "./bootstrap";

      dontWrapGApps = true;

      preFixup = ''
        makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
      '';

      postFixup = ''
        wrapPythonPrograms
        wrapGApp $out/bin/${pname}
      '';

      # the geoclue agent may inspect these paths and expect them to be
      # valid without having the correct $PATH set
      postInstall =
        if (pname == "gammastep") then
          ''
            substituteInPlace $out/share/applications/gammastep.desktop \
              --replace 'Exec=gammastep' "Exec=$out/bin/gammastep"
            substituteInPlace $out/share/applications/gammastep-indicator.desktop \
              --replace 'Exec=gammastep-indicator' "Exec=$out/bin/gammastep-indicator"
          ''
        else
          ''
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
      mainProgram = "redshift";
      maintainers = [ ];
    };
  };

  gammastep = mkRedshift rec {
    pname = "gammastep";
    version = "2.0.11";

    src = fetchFromGitLab {
      owner = "chinstrap";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-c8JpQLHHLYuzSC9bdymzRTF6dNqOLwYqgwUOpKcgAEU=";
    };

    meta = redshift.meta // {
      name = "${pname}-${version}";
      longDescription = "Gammastep" + lib.removePrefix "Redshift" redshift.meta.longDescription;
      homepage = "https://gitlab.com/chinstrap/gammastep";
      mainProgram = "gammastep";
      maintainers = (with lib.maintainers; [ ]) ++ redshift.meta.maintainers;
    };
  };
}
