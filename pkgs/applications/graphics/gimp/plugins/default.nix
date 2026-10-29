# Use `gimp-with-plugins` package for GIMP with all plug-ins.
# If you just want a subset of plug-ins, you can specify them explicitly:
# `gimp-with-plugins.override { plugins = with gimpPlugins; [ gap ]; }`.

{
  lib,
  pkgs,
  gimp,
}:

let
  inherit (pkgs)
    stdenv
    fetchurl
    fetchpatch
    pkg-config
    intltool
    glib
    fetchFromGitHub
    ;

  # We cannot use gimp from the arguments directly, or it would be shadowed by the one
  # from scope when initializing the scope with it, leading to infinite recursion.
  gimpArg = gimp;
in

lib.makeScope pkgs.newScope (
  self:

  let
    # Use GIMP from the scope.
    inherit (self) gimp;

    pluginDerivation =
      attrs:
      let
        name = attrs.name or "${attrs.pname}-${attrs.version}";
        pkgConfigMajorVersion = lib.versions.major gimp.version;
      in
      stdenv.mkDerivation (
        {
          prePhases = [ "extraLib" ];
          extraLib = ''
            installScripts(){
              mkdir -p $out/${gimp.targetScriptDir}/${name};
              for p in "$@"; do cp "$p" -r $out/${gimp.targetScriptDir}/${name}; done
            }
            installPlugin() {
              # The base name of the first argument is the plug-in name and the main executable.
              # GIMP only allows a single plug-in per directory:
              # https://gitlab.gnome.org/GNOME/gimp/-/commit/efae55a73e98389e38fa0e59ebebcda0abe3ee96
              pluginDir=$out/${gimp.targetPluginDir}/$(basename "$1")
              install -Dt "$pluginDir" "$@"
            }
          '';
        }
        // attrs
        // {
          name = "${gimp.pname}-plugin-${name}";
          buildInputs = [
            gimp
            gimp.gtk
            glib
          ]
          ++ (attrs.buildInputs or [ ]);

          nativeBuildInputs = [
            pkg-config
            intltool
          ]
          ++ (attrs.nativeBuildInputs or [ ]);

          # Override installation paths.
          env = {
            "PKG_CONFIG_GIMP_${pkgConfigMajorVersion}_0_GIMPLIBDIR" =
              "${placeholder "out"}/${gimp.targetLibDir}";
            "PKG_CONFIG_GIMP_${pkgConfigMajorVersion}_0_GIMPDATADIR" =
              "${placeholder "out"}/${gimp.targetDataDir}";
          }
          // attrs.env or { };
        }
      );

    scriptDerivation =
      { src, ... }@attrs:
      pluginDerivation (
        {
          prePhases = [ "extraLib" ];
          dontUnpack = true;
          installPhase = ''
            runHook preInstall
            installScripts ${src}
            runHook postInstall
          '';
        }
        // attrs
      );
  in
  {
    # Allow overriding GIMP package in the scope.
    gimp = gimpArg;

    resynthesizer = pluginDerivation rec {
      /*
        menu:
        Edit/Fill with pattern seamless...
        Filters/Enhance/Heal selection...
        Filters/Enhance/Heal transparency...
        Filters/Enhance/Sharpen by synthesis...
        Filters/Enhance/Uncrop...
        Filters/Map/Style...
        Filters/Render/Texture...
      */
      pname = "resynthesizer";
      version = "3.0";
      buildInputs = with pkgs; [ fftw ];
      nativeBuildInputs = with pkgs; [
        meson
        ninja
      ];
      makeFlags = [ "GIMP_LIBDIR=${placeholder "out"}/${gimp.targetLibDir}" ];
      src = fetchFromGitHub {
        owner = "bootchk";
        repo = "resynthesizer";
        tag = "v${version}";
        hash = "sha256-/Py5R1RxiftTR0z++mQzgTn/J9v4p8efuGZSfhe6FfA=";
      };

      meta = {
        broken = lib.versionOlder gimp.version "3";
        description = "Suite of gimp plugins for texture synthesis";
        homepage = "https://github.com/bootchk/resynthesizer";
        license = lib.licenses.gpl3Plus;
      };
    };

    gmic = pkgs.gmic-qt.override {
      variant = "gimp";
      inherit (self) gimp;
    };

    # =============== simple script files ====================

    lightning = scriptDerivation {
      pname = "Lightning";
      version = "0-unstable-2017-08-25";
      src = fetchurl {
        url = "https://github.com/pixlsus/registry.gimp.org_static/raw/master/registry.gimp.org/files/Lightning.scm";
        sha256 = "c14a8f4f709695ede3f77348728a25b3f3ded420da60f3f8de3944b7eae98a49";
      };
    };
  }
)
