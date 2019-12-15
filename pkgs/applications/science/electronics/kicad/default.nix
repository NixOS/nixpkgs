{ lib, stdenv, gnome3, pkgs, wxGTK30, wxGTK31
, gsettings-desktop-schemas, hicolor-icon-theme
, callPackage, callPackages
, librsvg, cups

, pname ? "kicad"
, oceSupport ? false, opencascade
, withOCCT ? true, opencascade-occt
, ngspiceSupport ? true, libngspice
, scriptingSupport ? true, swig, python3, python3Packages
, debug ? false, valgrind
, with3d ? true
, withI18n ? true
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let

  stable = pname != "kicad-unstable";

  versions = {
    "kicad" = {
      kicadVersion = {
        version = "5.1.5";
        src.sha256 = "15h3rwisjss3fdc9bam9n2wq94slhacc3fbg14bnzf4n5agsnv5b";
      };
      libVersion = {
        version = "5.1.5";
        libSources = {
          i18n.sha256 = "1rfpifl8vky1gba2angizlb2n7mwmsiai3r6ip6qma60wdj8sbd3";
          symbols.sha256 = "048b07ffsaav1ssrchw2p870lvb4rsyb5vnniy670k7q9p16qq6h";
          templates.sha256 = "0cs3bm3zb5ngw5ldn0lzw5bvqm4kvcidyrn76438alffwiz2b15g";
          footprints.sha256 = "1c4whgn14qhz4yqkl46w13p6rpv1k0hsc9s9h9368fxfcz9knb2j";
          packages3d.sha256 = "0cff2ms1bsw530kqb1fr1m2pjixyxzwa81mxgac3qpbcf8fnpvaz";
        };
      };
    };
    "kicad-unstable" = {
      kicadVersion = {
        version = "2019-12-15";
        src = {
          rev = "1abb198fb42c68ab8dd8ce6ff97d984df6688e10";
          sha256 = "1b7k05bl2w4by5bhk6sfb2iynddlg3gah8qma7l9am6q1j3lmx4p";
        };
      };
      libVersion = {
        version = "unstable";
        libSources = {
          i18n.rev = "f1084526305005fa53e78000f7db2d67e8a0d423";
          i18n.sha256 = "1yhc0m4psx0rz5msb1zqn5fz6l1ynwykrsk1443g4073lmjibv74";
          symbols.rev = "68176b08fdfd34673f4518ef6c331ad2ecf7a9a6";
          symbols.sha256 = "0kcn8pwdac5snd6vzmdw82k5x9q12nijpdss3nvi5my6g3ilwgjj";
          templates.rev = "0c0490897f803ab8b7c3dad438b7eb1f80e0417c";
          templates.sha256 = "0cs3bm3zb5ngw5ldn0lzw5bvqm4kvcidyrn76438alffwiz2b15g";
          footprints.rev = "8cef00a34078c3dabe943a76f9cdf7d05ffc38fc";
          footprints.sha256 = "0aplxxbcyb4vpj3kpcnj6lbnpk9zjql46js9i4iaqs388z93sb97";
          packages3d.rev = "58d73640ebb764637eb7bba6290815b84a24b8ad";
          packages3d.sha256 = "0cff2ms1bsw530kqb1fr1m2pjixyxzwa81mxgac3qpbcf8fnpvaz";
        };
      };
    };
  };
  versionConfig = versions.${if (stable) then "kicad" else "kicad-unstable"};

  wxGTK = if (stable)
    # wxGTK3x may default to withGtk2 = false, see #73145
    then wxGTK30.override { withGtk2 = false; }
    # wxGTK31 currently introduces an issue with opening the python interpreter in pcbnew
    # but brings high DPI support?
    else wxGTK31.override { withGtk2 = false; };

  pythonPackages = python3Packages;
  python = python3;
  wxPython = python3Packages.wxPython_4_0;

  kicad-libraries = callPackages ./libraries.nix versionConfig.libVersion;
  kicad-base = callPackage ./base.nix {
   pname = if (stable) then "kicad" else "kicad-unstable";
   inherit versions stable;
   inherit wxGTK python wxPython;
   inherit debug with3d withI18n withOCCT oceSupport ngspiceSupport scriptingSupport;
  };

in
stdenv.mkDerivation rec {

  inherit pname;
  version = versions.${if (stable) then "kicad" else "kicad-unstable"}.kicadVersion.version;

  src = kicad-base;

  pythonPath = optionals (scriptingSupport)
    [ wxPython pythonPackages.six ];

  nativeBuildInputs = optionals (scriptingSupport)
    [ pythonPackages.wrapPython ];

  # wrapGAppsHook added the equivalent to ${kicad-base}/share
  # though i noticed no difference without it
  makeWrapperArgs = [
    "--prefix XDG_DATA_DIRS : ${kicad-base}/share"
    "--prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share"
    "--prefix XDG_DATA_DIRS : ${gnome3.defaultIconTheme}/share"
    "--prefix XDG_DATA_DIRS : ${wxGTK.gtk}/share/gsettings-schemas/${wxGTK.gtk.name}"
    "--prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    # wrapGAppsHook did these two as well, no idea if it matters...
    "--prefix XDG_DATA_DIRS : ${cups}/share"
    "--prefix GIO_EXTRA_MODULES : ${gnome3.dconf}/lib/gio/modules"

    "--set KISYSMOD ${kicad-libraries.footprints}/share/kicad/modules"
    "--set KICAD_SYMBOL_DIR ${kicad-libraries.symbols}/share/kicad/library"
    "--set KICAD_TEMPLATE_DIR ${kicad-libraries.templates}/share/kicad/template"
    "--prefix KICAD_TEMPLATE_DIR : ${kicad-libraries.symbols}/share/kicad/template"
    "--prefix KICAD_TEMPLATE_DIR : ${kicad-libraries.footprints}/share/kicad/template"
  ]
  ++ optionals (ngspiceSupport) [ "--prefix LD_LIBRARY_PATH : ${libngspice}/lib" ]
  ++ optionals (with3d) [ "--set KISYS3DMOD ${kicad-libraries.packages3d}/share/kicad/modules/packages3d" ]

  # infinisil's workaround for #39493
  ++ [ "--set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]
  ;

  # dunno why i have to add $makeWrapperArgs manually...
  # $out and $program_PYTHONPATH don't exist when makeWrapperArgs gets set?
  # not sure if anything has to be done with the other stuff in kicad-base/bin
  # dxf2idf, idf2vrml, idfcyl, idfrect, kicad2step, kicad-ogltest
  installPhase =
    optionalString (scriptingSupport) '' buildPythonPath "$out $pythonPath"
    '' +
    '' makeWrapper ${kicad-base}/bin/kicad $out/bin/kicad $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' makeWrapper ${kicad-base}/bin/pcbnew $out/bin/pcbnew $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' makeWrapper ${kicad-base}/bin/eeschema $out/bin/eeschema $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' makeWrapper ${kicad-base}/bin/gerbview $out/bin/gerbview $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' makeWrapper ${kicad-base}/bin/pcb_calculator $out/bin/pcb_calculator $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' makeWrapper ${kicad-base}/bin/pl_editor $out/bin/pl_editor $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' makeWrapper ${kicad-base}/bin/bitmap2component $out/bin/bitmap2component $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    ''
  ;

  meta = {
    description = if (stable)
      then "Open Source Electronics Design Automation Suite"
      else "Open Source EDA Suite, Development Build";
    homepage = "https://www.kicad-pcb.org/";
    longDescription = ''
      KiCad is an open source software suite for Electronic Design Automation.
      The Programs handle Schematic Capture, and PCB Layout with Gerber output.
    '';
    license = licenses.agpl3;
    # berce seems inactive...
    maintainers = with maintainers; [ evils kiwi berce ];
    # kicad's cross-platform, not sure what to fill in here
    platforms = with platforms; linux;
  };
}
