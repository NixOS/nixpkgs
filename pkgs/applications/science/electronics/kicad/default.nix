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
  baseName = if (stable) then "kicad" else "kicad-unstable";

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
        version = "2019-12-31";
        src = {
          rev = "eaaa4eb63acb289047dfbb6cc275579dea58f12b";
          sha256 = "1v2hf2slphjdh14y56pmzlpi6mqidrd8198if1fi0cch72v37zch";
        };
      };
      libVersion = {
        version = "unstable";
        libSources = {
          i18n.rev = "e7439fd76f27cfc26e269c4e6c4d56245345c28b";
          i18n.sha256 = "1nqm1kx5b4f7s0f9q8bg4rdhqnp0128yp6bgnrkia1kwmfnf5gmy";
          symbols.rev = "1bc5ff11c76bcbfda227e534b0acf737edddde8f";
          symbols.sha256 = "05kv93790wi4dpbn2488p587b83yz1zw9h62lkv41h7vn2r1mmb7";
          templates.rev = "0c0490897f803ab8b7c3dad438b7eb1f80e0417c";
          templates.sha256 = "0cs3bm3zb5ngw5ldn0lzw5bvqm4kvcidyrn76438alffwiz2b15g";
          footprints.rev = "454126c125edd3fa8633f301421a7d9c4de61b77";
          footprints.sha256 = "00nli4kx2i68bk852rivbirzcgpsdlpdk34g1q892952jsbh7fy6";
          packages3d.rev = "c2b92a411adc93ddeeed74b36b542e1057f81a2a";
          packages3d.sha256 = "05znc6y2lc31iafspg308cxdda94zg6c7mwslmys76npih1pb8qc";
        };
      };
    };
  };
  versionConfig = versions.${baseName};

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
    pname = baseName;
    inherit versions stable baseName;
    inherit wxGTK python wxPython;
    inherit debug withI18n withOCCT oceSupport ngspiceSupport scriptingSupport;
  };

in
stdenv.mkDerivation rec {

  inherit pname;
  version = versions.${baseName}.kicadVersion.version;

  src = kicad-base;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

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
  ++ optionals (with3d) [ "--set KISYS3DMOD ${kicad-libraries.packages3d}/share/kicad/modules/packages3d" ]
  ++ optionals (ngspiceSupport) [ "--prefix LD_LIBRARY_PATH : ${libngspice}/lib" ]

  # infinisil's workaround for #39493
  ++ [ "--set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]
  ;

  # dunno why i have to add $makeWrapperArgs manually...
  # $out and $program_PYTHONPATH don't exist when makeWrapperArgs gets set?
  # not sure if anything has to be done with the other stuff in kicad-base/bin
  # dxf2idf, idf2vrml, idfcyl, idfrect, kicad2step, kicad-ogltest
  installPhase =
    optionalString (scriptingSupport) '' buildPythonPath "${kicad-base} $pythonPath"
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
