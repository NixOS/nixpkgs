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
    fetchpatch2
    pkg-config
    intltool
    glib
    fetchFromGitHub
    fetchFromGitLab
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

    bimp = pluginDerivation rec {
      /*
        menu:
        File/Batch Image Manipulation...
      */
      pname = "bimp";
      version = "2.6";

      src = fetchFromGitHub {
        owner = "alessandrofrancesconi";
        repo = "gimp-plugin-bimp";
        rev = "v${version}";
        hash = "sha256-IJ3+/9UwxJTRo0hUdzlOndOHwso1wGv7Q4UuhbsFkco=";
      };

      patches = [
        # Allow overriding installation path
        # https://github.com/alessandrofrancesconi/gimp-plugin-bimp/pull/311
        (fetchpatch {
          url = "https://github.com/alessandrofrancesconi/gimp-plugin-bimp/commit/098edb5f70a151a3f377478fd6e0d08ed56b8ef7.patch";
          sha256 = "2Afx9fmdn6ztbsll2f2j7mfffMWYWyr4BuBy9ySV6vM=";
        })
      ];

      postPatch = ''
        substituteInPlace Makefile \
          --replace-fail "gcc" "${stdenv.cc.targetPrefix}cc"
      '';

      nativeBuildInputs = with pkgs; [ which ];

      # workaround for issue:
      # https://github.com/alessandrofrancesconi/gimp-plugin-bimp/issues/411
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

      installFlags = [
        "SYSTEM_INSTALL_DIR=${placeholder "out"}/${gimp.targetPluginDir}/bimp"
      ];

      installTargets = [ "install-admin" ];

      meta = with lib; {
        broken = gimp.majorVersion != "2.0";
        description = "Batch Image Manipulation Plugin for GIMP";
        homepage = "https://github.com/alessandrofrancesconi/gimp-plugin-bimp";
        license = licenses.gpl2Plus;
        maintainers = [ ];
      };
    };

    farbfeld = pluginDerivation {
      pname = "farbfeld";
      version = "unstable-2019-08-12";

      src = fetchFromGitHub {
        owner = "ids1024";
        repo = "gimp-farbfeld";
        rev = "5feacebf61448bd3c550dda03cd08130fddc5af4";
        sha256 = "1vmw7k773vrndmfffj0m503digdjmkpcqy2r3p3i5x0qw9vkkkc6";
      };

      installPhase = ''
        installPlugin farbfeld
      '';

      meta = {
        broken = gimp.majorVersion != "2.0";
        description = "Gimp plug-in for the farbfeld image format";
        homepage = "https://github.com/ids1024/gimp-farbfeld";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ sikmir ];
      };
    };

    fourier = pluginDerivation rec {
      /*
        menu:
        Filters/Generic/FFT Forward
        Filters/Generic/FFT Inverse
      */
      pname = "fourier";
      version = "0.4.3";

      src = fetchurl {
        url = "https://www.lprp.fr/files/old-web/soft/gimp/${pname}-${version}.tar.gz";
        sha256 = "0mf7f8vaqs2madx832x3kcxw3hv3w3wampvzvaps1mkf2kvrjbsn";
      };

      buildInputs = with pkgs; [ fftw ];

      postPatch = ''
        substituteInPlace Makefile --replace '$(GCC)' '$(CC)'

        # The tarball contains a prebuilt binary.
        make clean
      '';

      installPhase = ''
        runHook preInstall

        installPlugin fourier

        runHook postInstall
      '';

      meta = with lib; {
        broken = gimp.majorVersion != "2.0";
        description = "GIMP plug-in to do the fourier transform";
        homepage = "https://people.via.ecp.fr/~remi/soft/gimp/gimp_plugin_en.php3#fourier";
        license = with licenses; [ gpl3Plus ];
      };
    };

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
      version = "2.0.3";
      buildInputs = with pkgs; [ fftw ];
      nativeBuildInputs = with pkgs; [ autoreconfHook ];
      makeFlags = [ "GIMP_LIBDIR=${placeholder "out"}/${gimp.targetLibDir}" ];
      src = fetchFromGitHub {
        owner = "bootchk";
        repo = "resynthesizer";
        rev = "v${version}";
        sha256 = "1jwc8bhhm21xhrgw56nzbma6fwg59gc8anlmyns7jdiw83y0zx3j";
      };

      meta = {
        broken = gimp.majorVersion != "2.0";
      };
    };

    texturize = pluginDerivation {
      pname = "texturize";
      version = "2.2+unstable=2021-12-03";
      src = fetchFromGitHub {
        owner = "lmanul";
        repo = "gimp-texturize";
        rev = "9ceff0d411cda018108e5477320669b8d00d811e";
        sha256 = "haYS0K3oAPlHtHB8phOCX5/gtWq9uiVQhG5ZhAFX0t0=";
      };
      nativeBuildInputs = with pkgs; [
        meson
        ninja
        gettext
      ];

      meta = {
        broken = gimp.majorVersion != "2.0";
      };
    };

    waveletSharpen = pluginDerivation {
      /*
        menu:
        Filters/Enhance/Wavelet sharpen
      */
      pname = "wavelet-sharpen";
      version = "0.1.2";

      src = fetchurl {
        url = "https://github.com/pixlsus/registry.gimp.org_static/raw/master/registry.gimp.org/files/wavelet-sharpen-0.1.2.tar.gz";
        sha256 = "0vql1k67i21g5ivaa1jh56rg427m0icrkpryrhg75nscpirfxxqw";
      };

      env = {
        # Workaround build failure on -fno-common toolchains like upstream
        # gcc-10. Otherwise build fails as:
        #   ld: interface.o:(.bss+0xe0): multiple definition of `fimg'; plugin.o:(.bss+0x40): first defined here
        NIX_CFLAGS_COMPILE = "-fcommon";
        NIX_LDFLAGS = "-lm";
      };

      installPhase = "installPlugin src/wavelet-sharpen"; # TODO translations are not copied .. How to do this on nix?

      meta = {
        broken = gimp.majorVersion != "2.0";
      };
    };

    lqrPlugin = pluginDerivation rec {
      /*
        menu:
        Layer/Liquid Rescale
      */
      pname = "lqr-plugin";
      version = "0.7.2";
      buildInputs = with pkgs; [ liblqr1 ];
      src = fetchFromGitHub {
        owner = "carlobaldassi";
        repo = "gimp-lqr-plugin";
        rev = "v${version}";
        sha256 = "81ajdZ2zQi/THxnBlSeT36tVTEzrS1YqLGpHMhFTKAo=";
      };
      patches = [
        # Pull upstream fix for -fno-common toolchain support:
        #   https://github.com/carlobaldassi/gimp-lqr-plugin/pull/6
        (fetchpatch {
          name = "fno-common.patch";
          url = "https://github.com/carlobaldassi/gimp-lqr-plugin/commit/ae3464a82e1395fc577cc94999bdc7c4a7bb35f1.patch";
          sha256 = "EdjZWM6U1bhUmsOnLA8iJ4SFKuAXHIfNPzxZqel+JrY=";
        })
      ];

      meta = {
        broken = gimp.majorVersion != "2.0";
      };
    };

    gmic = pkgs.gmic-qt.override {
      variant = "gimp";
      inherit (self) gimp;
    };

    gimplensfun = pluginDerivation {
      version = "unstable-2018-10-21";
      pname = "gimplensfun";

      src = fetchFromGitHub {
        owner = "seebk";
        repo = "GIMP-Lensfun";
        rev = "1c5a5c1534b5faf098b7441f8840d22835592f17";
        sha256 = "1jj3n7spkjc63aipwdqsvq9gi07w13bb1v8iqzvxwzld2kxa3c8w";
      };

      buildInputs = (
        with pkgs;
        [
          lensfun
          gexiv2
        ]
        ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
      );

      installPhase = "
      installPlugin gimp-lensfun
    ";

      meta = {
        broken = gimp.majorVersion != "2.0";
        description = "GIMP plugin to correct lens distortion using the lensfun library and database";

        homepage = "http://lensfun.sebastiankraft.net/";

        license = lib.licenses.gpl3Plus;
        maintainers = [ ];
      };
    };

    # =============== simple script files ====================

    lightning = scriptDerivation {
      name = "Lightning";
      src = fetchurl {
        url = "https://github.com/pixlsus/registry.gimp.org_static/raw/master/registry.gimp.org/files/Lightning.scm";
        sha256 = "c14a8f4f709695ede3f77348728a25b3f3ded420da60f3f8de3944b7eae98a49";
      };
    };
  }
)
