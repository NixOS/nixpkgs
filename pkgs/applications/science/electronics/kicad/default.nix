{ lib, stdenv, gnome3, wxGTK30, wxGTK31
, makeWrapper
, gsettings-desktop-schemas, hicolor-icon-theme
, callPackage, callPackages
, librsvg, cups

, pname ? "kicad"
, stable ? true
, oceSupport ? false, opencascade
, withOCCT ? true, opencascade-occt
, ngspiceSupport ? true, libngspice
, scriptingSupport ? false, swig, python3
, debug ? false, valgrind
, with3d ? true
, withI18n ? true
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let

  baseName = if (stable) then "kicad" else "kicad-unstable";

  versions =  import ./versions.nix;
  versionConfig = versions.${baseName};

  wxGTK = if (stable)
    # wxGTK3x may default to withGtk2 = false, see #73145
    then wxGTK30.override { withGtk2 = false; }
    # wxGTK31 currently introduces an issue with opening the python interpreter in pcbnew
    # but brings high DPI support?
    else wxGTK31.override { withGtk2 = false; };

  python = python3;
  wxPython = python.pkgs.wxPython_4_0;

in
stdenv.mkDerivation rec {

  passthru.libraries = callPackages ./libraries.nix versionConfig.libVersion;
  base = callPackage ./base.nix {
    inherit versions stable baseName;
    inherit wxGTK python wxPython;
    inherit debug withI18n withOCCT oceSupport ngspiceSupport scriptingSupport;
  };

  inherit pname;
  version = versions.${baseName}.kicadVersion.version;

  src = base;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  pythonPath = optionals (scriptingSupport)
    [ wxPython python.pkgs.six ];

  nativeBuildInputs = [ makeWrapper ]
    ++ optionals (scriptingSupport)
      [ python.pkgs.wrapPython ];

  # wrapGAppsHook added the equivalent to ${base}/share
  # though i noticed no difference without it
  makeWrapperArgs = with passthru.libraries; [
    "--prefix XDG_DATA_DIRS : ${base}/share"
    "--prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share"
    "--prefix XDG_DATA_DIRS : ${gnome3.defaultIconTheme}/share"
    "--prefix XDG_DATA_DIRS : ${wxGTK.gtk}/share/gsettings-schemas/${wxGTK.gtk.name}"
    "--prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    # wrapGAppsHook did these two as well, no idea if it matters...
    "--prefix XDG_DATA_DIRS : ${cups}/share"
    "--prefix GIO_EXTRA_MODULES : ${gnome3.dconf}/lib/gio/modules"

    "--set KISYSMOD ${footprints}/share/kicad/modules"
    "--set KICAD_SYMBOL_DIR ${symbols}/share/kicad/library"
    "--set KICAD_TEMPLATE_DIR ${templates}/share/kicad/template"
    "--prefix KICAD_TEMPLATE_DIR : ${symbols}/share/kicad/template"
    "--prefix KICAD_TEMPLATE_DIR : ${footprints}/share/kicad/template"
  ]
  ++ optionals (with3d) [ "--set KISYS3DMOD ${packages3d}/share/kicad/modules/packages3d" ]
  ++ optionals (ngspiceSupport) [ "--prefix LD_LIBRARY_PATH : ${libngspice}/lib" ]

  # infinisil's workaround for #39493
  ++ [ "--set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]
  ;

  # why does $makeWrapperArgs have to be added explicitly?
  # $out and $program_PYTHONPATH don't exist when makeWrapperArgs gets set?
  # kicad-ogltest's source seems to indicate that crashing is expected behaviour...
  installPhase = with lib;
    let
      tools = [ "kicad" "pcbnew" "eeschema" "gerbview" "pcb_calculator" "pl_editor" "bitmap2component" ];
      utils = [ "dxf2idf" "idf2vrml" "idfcyl" "idfrect" "kicad2step" "kicad-ogltest" ];
    in
    ( concatStringsSep "\n"
      ( flatten [
        ( optionalString (scriptingSupport) "buildPythonPath \"${base} $pythonPath\" \n" )

        # wrap each of the directly usable tools
        ( map ( tool: "makeWrapper ${base}/bin/${tool} $out/bin/${tool} $makeWrapperArgs"
          + optionalString (scriptingSupport) " --set PYTHONPATH \"$program_PYTHONPATH\""
            ) tools )

        # link in the CLI utils
        ( map ( util: "ln -s ${base}/bin/${util} $out/bin/${util}" ) utils )
      ])
    )
  ;

  # can't run this for each pname
  # stable and unstable are in the same versions.nix
  # and kicad-small reuses stable
  # with "all" it updates both, run it manually if you don't want that
  # and can't git commit if this could be running in parallel with other scripts
  passthru.updateScript = [ ./update.sh "all" ];

  meta = rec {
    description = (if (stable)
      then "Open Source Electronics Design Automation suite"
      else "Open Source EDA suite, development build")
      + (if (!with3d) then ", without 3D models" else "");
    homepage = "https://www.kicad-pcb.org/";
    longDescription = ''
      KiCad is an open source software suite for Electronic Design Automation.
      The Programs handle Schematic Capture, and PCB Layout with Gerber output.
    '';
    license = licenses.agpl3;
    # berce seems inactive...
    maintainers = with stdenv.lib.maintainers; [ evils kiwi berce ];
    # kicad is cross platform
    platforms = stdenv.lib.platforms.all;
    # despite that, nipkgs' wxGTK for darwin is "wxmac"
    # and wxPython_4_0 does not account for this
    # adjusting this package to downgrade to python2Packages.wxPython (wxPython 3),
    # seems like more trouble than fixing wxPython_4_0 would be
    # additionally, libngspice is marked as linux only, though it should support darwin

    hydraPlatforms = if (with3d) then [ ] else platforms;
    # We can't download the 3d models on Hydra,
    # they are a ~1 GiB download and they occupy ~5 GiB in store.
    # as long as the base and libraries (minus 3d) are build,
    # this wrapper does not need to get built
    # the kicad-*small "packages" cause this to happen
  };
}
