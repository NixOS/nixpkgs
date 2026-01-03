{
  lib,
  stdenv,
  # The unwrapped gnuradio derivation
  unwrapped,
  # If it's a minimal build, we don't want to wrap it with lndir and
  # wrapProgram..
  doWrap ? true,
  # For the wrapper
  makeWrapper,
  # For lndir
  xorg,
  # To define a the gnuradio.pkgs scope
  newScope,
  # For Emulating wrapGAppsHook3
  gsettings-desktop-schemas,
  glib,
  hicolor-icon-theme,
  pango,
  json-glib,
  dconf,
  gobject-introspection,
  librsvg,
  gdk-pixbuf,
  harfbuzz,
  at-spi2-core,
  atk,
  # For Adding additional GRC blocks
  extraPackages ? [ ],
  # For Adding additional python packaages
  extraPythonPackages ? [ ],
  soapysdr, # For it's passthru.searchPath
  # soapysdr plugins we add by default. Ideally, we should have a
  # soapysdrPackages = soapysdr.pkgs attribute set, but until now this wasn't
  # crucial.
  soapyairspy,
  soapyaudio,
  soapybladerf,
  soapyhackrf,
  soapyplutosdr,
  soapyremote,
  soapyrtlsdr,
  soapyuhd,
  # For adding / changing soapysdr packages, like soapsdr-with-plugins does
  extraSoapySdrPackages ? [
    soapyairspy
    soapyaudio
    soapybladerf
    soapyhackrf
    soapyplutosdr
    soapyremote
    soapyrtlsdr
    soapyuhd
  ],
  # Allow to add whatever you want to the wrapper
  extraMakeWrapperArgs ? [ ],
}:

let
  # We don't check if `python-support` feature is on, as it's unlikely someone
  # may wish to wrap GR without python support.
  pythonPkgs =
    extraPythonPackages
    ++ [ (unwrapped.python.pkgs.toPythonModule unwrapped) ]
    ++ unwrapped.passthru.uhd.pythonPath
    ++ lib.optionals (unwrapped.passthru.uhd.pythonPath != [ ]) [
      (unwrapped.python.pkgs.toPythonModule unwrapped.passthru.uhd)
    ]
    # Add the extraPackages as python modules as well
    ++ (map unwrapped.python.pkgs.toPythonModule extraPackages)
    ++ lib.flatten (
      lib.mapAttrsToList (
        feat: info:
        (lib.optionals (
          (unwrapped.hasFeature feat) && (builtins.hasAttr "pythonRuntime" info)
        ) info.pythonRuntime)
      ) unwrapped.featuresInfo
    );
  pythonEnv = unwrapped.python.withPackages (ps: pythonPkgs);

  pname = unwrapped.pname + "-wrapped";
  inherit (unwrapped) version;
  makeWrapperArgs = builtins.concatStringsSep " " (
    [
    ]
    # Emulating wrapGAppsHook3 & wrapQtAppsHook working together
    ++
      lib.optionals ((unwrapped.hasFeature "gnuradio-companion") || (unwrapped.hasFeature "gr-qtgui"))
        [
          "--prefix"
          "XDG_DATA_DIRS"
          ":"
          "$out/share"
          "--prefix"
          "XDG_DATA_DIRS"
          ":"
          "$out/share/gsettings-schemas/${pname}"
          "--prefix"
          "XDG_DATA_DIRS"
          ":"
          "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
          "--prefix"
          "XDG_DATA_DIRS"
          ":"
          "${hicolor-icon-theme}/share"
          # Needs to run `gsettings` on startup, see:
          # https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1764890.html
          "--prefix"
          "PATH"
          ":"
          "${lib.getBin glib}/bin"
        ]
    ++ lib.optionals (unwrapped.hasFeature "gnuradio-companion") [
      "--set"
      "GDK_PIXBUF_MODULE_FILE"
      "${librsvg}/${gdk-pixbuf.moduleDir}.cache"
      "--prefix"
      "GIO_EXTRA_MODULES"
      ":"
      "${lib.getLib dconf}/lib/gio/modules"
      "--prefix"
      "XDG_DATA_DIRS"
      ":"
      "${unwrapped.gtk}/share"
      "--prefix"
      "XDG_DATA_DIRS"
      ":"
      "${unwrapped.gtk}/share/gsettings-schemas/${unwrapped.gtk.name}"
      "--prefix"
      "GI_TYPELIB_PATH"
      ":"
      "${lib.makeSearchPath "lib/girepository-1.0" [
        (lib.getLib glib)
        unwrapped.gtk
        gsettings-desktop-schemas
        atk
        # From some reason, if .out is not used, .bin is used, and we want
        # what's in `.out`.
        pango.out
        gdk-pixbuf
        json-glib
        harfbuzz
        librsvg
        gobject-introspection
        at-spi2-core
      ]}"
    ]
    ++ lib.optionals (extraPackages != [ ]) [
      "--prefix"
      "GRC_BLOCKS_PATH"
      ":"
      "${lib.makeSearchPath "share/gnuradio/grc/blocks" extraPackages}"
    ]
    ++ lib.optionals (extraSoapySdrPackages != [ ]) [
      "--prefix"
      "SOAPY_SDR_PLUGIN_PATH"
      ":"
      "${lib.makeSearchPath soapysdr.passthru.searchPath extraSoapySdrPackages}"
    ]
    ++
      lib.optionals (unwrapped.hasFeature "gr-qtgui")
        # 3.7 builds with qt4
        (
          if lib.versionAtLeast unwrapped.versionAttr.major "3.8" then
            [
              "--prefix"
              "QT_PLUGIN_PATH"
              ":"
              "${lib.makeSearchPath unwrapped.qt.qtbase.qtPluginPrefix (
                map lib.getBin (
                  [
                    unwrapped.qt.qtbase
                  ]
                  ++ lib.optionals stdenv.hostPlatform.isLinux [
                    unwrapped.qt.qtwayland
                  ]
                )
              )}"
              "--prefix"
              "QML2_IMPORT_PATH"
              ":"
              "${lib.makeSearchPath unwrapped.qt.qtbase.qtQmlPrefix (
                map lib.getBin (
                  [
                    unwrapped.qt.qtbase
                  ]
                  ++ lib.optionals stdenv.hostPlatform.isLinux [
                    unwrapped.qt.qtwayland
                  ]
                )
              )}"
            ]
          else
            # Add here qt4 related environment for 3.7?
            [

            ]
        )
    ++ extraMakeWrapperArgs
  );

  packages = import ../../../top-level/gnuradio-packages.nix {
    inherit lib stdenv newScope;
    gnuradio = unwrapped;
  };
  passthru = unwrapped.passthru // {
    inherit
      pythonEnv
      pythonPkgs
      unwrapped
      ;
    pkgs = packages;
  };
  self =
    if doWrap then
      stdenv.mkDerivation {
        inherit pname version passthru;
        nativeBuildInputs = [ makeWrapper ];
        buildInputs = [
          xorg.lndir
        ];
        buildCommand = ''
          mkdir $out
          cd $out
          lndir -silent ${unwrapped}
          ${lib.optionalString (extraPackages != [ ]) (
            builtins.concatStringsSep "\n" (
              map (pkg: ''
                if [[ -d ${lib.getBin pkg}/bin/ ]]; then
                  lndir -silent ${pkg}/bin ./bin
                fi
              '') extraPackages
            )
          )}
          for i in $out/bin/*; do
            if [[ ! -x "$i" ]]; then
              continue
            fi
            cp -L "$i" "$i".tmp
            mv -f "$i".tmp "$i"
            if head -1 "$i" | grep -q ${unwrapped.python}; then
              substituteInPlace "$i" \
                --replace ${unwrapped.python} ${pythonEnv}
            fi
            wrapProgram "$i" ${makeWrapperArgs}
          done
        '';
        inherit (unwrapped) meta;
      }
    else
      unwrapped.overrideAttrs (_: {
        inherit passthru;
      });
in
self
