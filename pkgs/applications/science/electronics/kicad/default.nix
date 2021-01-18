{ lib, stdenv
, fetchFromGitLab
, gnome3
, wxGTK30
, wxGTK31
, makeWrapper
, gsettings-desktop-schemas
, hicolor-icon-theme
, callPackage
, callPackages
, librsvg
, cups

, pname ? "kicad"
, stable ? true
, oceSupport ? false
, withOCE ? false
, opencascade
, withOCCT ? false
, withOCC ? true
, opencascade-occt
, ngspiceSupport ? false
, withNgspice ? true
, libngspice
, scriptingSupport ? false
, withScripting ? true
, swig
, python3
, debug ? false
, valgrind
, with3d ? true
, withI18n ? true
, srcs ? { }
}:

# The `srcs` parameter can be used to override the kicad source code
# and all libraries (including i18n), which are otherwise inaccessible
# to overlays since most of the kicad build expression has been
# refactored into base.nix, most of the library build expressions have
# been refactored into libraries.nix, and most the i18n build
# expression has been refactored into i18n.nix. Overrides are only
# applied when building `kicad-unstable`. The `srcs` parameter has no
# effect for stable `kicad`. `srcs` takes an attribute set in which
# any of the following attributes are meaningful (though none are
# mandatory): "kicad", "kicadVersion", "i18n", "symbols", "templates",
# "footprints", "packages3d", and "libVersion". "kicadVersion" and
# "libVersion" should be set to a string with the desired value for
# the version attribute in kicad's `mkDerivation` and the version
# attribute in any of the library's or i18n's `mkDerivation`,
# respectively. "kicad", "i18n", "symbols", "templates", "footprints",
# and "packages3d" should be set to an appropriate fetcher (e.g.,
# `fetchFromGitLab`). So, for example, a possible overlay for kicad
# is:
#
# final: prev:

# {
#   kicad-unstable = (prev.kicad-unstable.override {
#     srcs = {
#       kicadVersion = "2020-10-08";
#       kicad = prev.fetchFromGitLab {
#         group = "kicad";
#         owner = "code";
#         repo = "kicad";
#         rev = "fd22fe8e374ce71d57e9f683ba996651aa69fa4e";
#         sha256 = "sha256-F8qugru/jU3DgZSpQXQhRGNFSk0ybFRkpyWb7HAGBdc=";
#       };
#     };
#   });
# }

assert withNgspice -> libngspice != null;
assert lib.assertMsg (!ngspiceSupport)
  "`nspiceSupport` was renamed to `withNgspice` for the sake of consistency with other kicad nix arguments.";
assert lib.assertMsg (!oceSupport)
  "`oceSupport` was renamed to `withOCE` for the sake of consistency with other kicad nix arguments.";
assert lib.assertMsg (!scriptingSupport)
  "`scriptingSupport` was renamed to `withScripting` for the sake of consistency with other kicad nix arguments.";
assert lib.assertMsg (!withOCCT)
  "`withOCCT` was renamed to `withOCC` for the sake of consistency with upstream cmake options.";
let
  baseName = if (stable) then "kicad" else "kicad-unstable";
  versionsImport = import ./versions.nix;

  # versions.nix does not provide us with version, src and rev. We
  # need to turn this into approprate fetcher calls.
  kicadSrcFetch = fetchFromGitLab {
    group = "kicad";
    owner = "code";
    repo = "kicad";
    rev = versionsImport.${baseName}.kicadVersion.src.rev;
    sha256 = versionsImport.${baseName}.kicadVersion.src.sha256;
  };

  i18nSrcFetch = fetchFromGitLab {
    group = "kicad";
    owner = "code";
    repo = "kicad-i18n";
    rev = versionsImport.${baseName}.libVersion.libSources.i18n.rev;
    sha256 = versionsImport.${baseName}.libVersion.libSources.i18n.sha256;
  };

  libSrcFetch = name: fetchFromGitLab {
    group = "kicad";
    owner = "libraries";
    repo = "kicad-${name}";
    rev = versionsImport.${baseName}.libVersion.libSources.${name}.rev;
    sha256 = versionsImport.${baseName}.libVersion.libSources.${name}.sha256;
  };

  # only override `src` or `version` if building `kicad-unstable` with
  # the appropriate attribute defined in `srcs`.
  srcOverridep = attr: (!stable && builtins.hasAttr attr srcs);

  # use default source and version (as defined in versions.nix) by
  # default, or use the appropriate attribute from `srcs` if building
  # unstable with `srcs` properly defined.
  kicadSrc =
    if srcOverridep "kicad" then srcs.kicad
    else kicadSrcFetch;
  kicadVersion =
    if srcOverridep "kicadVersion" then srcs.kicadVersion
    else versionsImport.${baseName}.kicadVersion.version;

  i18nSrc = if srcOverridep "i18n" then srcs.i18n else i18nSrcFetch;
  i18nVersion =
    if srcOverridep "i18nVersion" then srcs.i18nVersion
    else versionsImport.${baseName}.libVersion.version;

  libSrc = name: if srcOverridep name then srcs.${name} else libSrcFetch name;
  # TODO does it make sense to only have one version for all libs?
  libVersion =
    if srcOverridep "libVersion" then srcs.libVersion
    else versionsImport.${baseName}.libVersion.version;

  wxGTK =
    if (stable)
    # wxGTK3x may default to withGtk2 = false, see #73145
    then
      wxGTK30.override
        {
          withGtk2 = false;
        }
    # wxGTK31 currently introduces an issue with opening the python interpreter in pcbnew
    # but brings high DPI support?
    else
      wxGTK31.override {
        withGtk2 = false;
      };

  python = python3;
  wxPython = python.pkgs.wxPython_4_0;

  inherit (lib) concatStringsSep flatten optionalString optionals;
in
stdenv.mkDerivation rec {

  # Common libraries, referenced during runtime, via the wrapper.
  passthru.libraries = callPackages ./libraries.nix { inherit libSrc libVersion; };
  passthru.i18n = callPackage ./i18n.nix {
    src = i18nSrc;
    version = i18nVersion;
  };
  base = callPackage ./base.nix {
    inherit stable baseName;
    inherit kicadSrc kicadVersion;
    inherit (passthru) i18n;
    inherit wxGTK python wxPython;
    inherit debug withI18n withOCC withOCE withNgspice withScripting;
  };

  inherit pname;
  version = kicadVersion;

  src = base;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  pythonPath = optionals (withScripting)
    [ wxPython python.pkgs.six ];

  nativeBuildInputs = [ makeWrapper ]
    ++ optionals (withScripting)
    [ python.pkgs.wrapPython ];

  # We are emulating wrapGAppsHook, along with other variables to the
  # wrapper
  makeWrapperArgs = with passthru.libraries; [
    "--prefix XDG_DATA_DIRS : ${base}/share"
    "--prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share"
    "--prefix XDG_DATA_DIRS : ${gnome3.defaultIconTheme}/share"
    "--prefix XDG_DATA_DIRS : ${wxGTK.gtk}/share/gsettings-schemas/${wxGTK.gtk.name}"
    "--prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    # wrapGAppsHook did these two as well, no idea if it matters...
    "--prefix XDG_DATA_DIRS : ${cups}/share"
    "--prefix GIO_EXTRA_MODULES : ${gnome3.dconf}/lib/gio/modules"

    "--set-default KISYSMOD ${footprints}/share/kicad/modules"
    "--set-default KICAD_SYMBOL_DIR ${symbols}/share/kicad/library"
    "--set-default KICAD_TEMPLATE_DIR ${templates}/share/kicad/template"
    "--prefix KICAD_TEMPLATE_DIR : ${symbols}/share/kicad/template"
    "--prefix KICAD_TEMPLATE_DIR : ${footprints}/share/kicad/template"
  ]
  ++ optionals (with3d) [ "--set-default KISYS3DMOD ${packages3d}/share/kicad/modules/packages3d" ]
  ++ optionals (withNgspice) [ "--prefix LD_LIBRARY_PATH : ${libngspice}/lib" ]

  # infinisil's workaround for #39493
  ++ [ "--set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]
  ;

  # why does $makeWrapperArgs have to be added explicitly?
  # $out and $program_PYTHONPATH don't exist when makeWrapperArgs gets set?
  installPhase =
    let
      tools = [ "kicad" "pcbnew" "eeschema" "gerbview" "pcb_calculator" "pl_editor" "bitmap2component" ];
      utils = [ "dxf2idf" "idf2vrml" "idfcyl" "idfrect" "kicad2step" ];
    in
    (concatStringsSep "\n"
      (flatten [
        (optionalString (withScripting) "buildPythonPath \"${base} $pythonPath\" \n")

        # wrap each of the directly usable tools
        (map
          (tool: "makeWrapper ${base}/bin/${tool} $out/bin/${tool} $makeWrapperArgs"
            + optionalString (withScripting) " --set PYTHONPATH \"$program_PYTHONPATH\""
          )
          tools)

        # link in the CLI utils
        (map (util: "ln -s ${base}/bin/${util} $out/bin/${util}") utils)
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
    license = lib.licenses.agpl3;
    # berce seems inactive...
    maintainers = with lib.maintainers; [ evils kiwi berce ];
    # kicad is cross platform
    platforms = lib.platforms.all;
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
