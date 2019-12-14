{ lib, stdenv, fetchFromGitLab, cmake, libGLU, libGL, zlib, wxGTK
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp, makeWrapper, gnome3
, gsettings-desktop-schemas, librsvg, hicolor-icon-theme, cups
, fetchpatch, lndir, callPackages

, pname ? "kicad"
, oceSupport ? false, opencascade
, withOCCT ? true, opencascade-occt
, ngspiceSupport ? true, libngspice
, scriptingSupport ? true, swig, python, pythonPackages, wxPython
, debug ? false, valgrind
, with3d ? true
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let
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
        version = "2019-12-14";
        src = {
          rev = "74caf3b7cb89f5bff86ad470bed67d200f445ba5";
          sha256 = "083f79plfmxiwgbaldgqi1bqq01g2r153x3c4n7ipi2dn7m5f1lr";
        };
      };
      libVersion = {
        version = "unstable";
        libSources = {
          i18n.rev = "f1084526305005fa53e78000f7db2d67e8a0d423";
          i18n.sha256 = "1yhc0m4psx0rz5msb1zqn5fz6l1ynwykrsk1443g4073lmjibv74";
          symbols.rev = "6dd82f11e4b2e60946dd07459e579cee0d42ca75";
          symbols.sha256 = "07mzaxn2isc6kj9zxl7syi013y4dfv5bvw9vlllbg8624mpwdibz";
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
  versionConfig = versions.${pname};

  # oce on aarch64 fails a test
  withOCC = withOCCT || (stdenv.isAarch64 && oceSupport);
  withOCE = oceSupport && !stdenv.isAarch64 && !withOCC;
  kicad-libraries = callPackages ./libraries.nix versionConfig.libVersion;
in
stdenv.mkDerivation rec {

  inherit pname;
  version = versions.${pname}.kicadVersion.version;

  src = fetchFromGitLab ({
    group = "kicad";
    owner = "code";
    repo = "kicad";
    rev = version;
  } // versionConfig.kicadVersion.src);

  # quick fix for #72248
  # should be removed if a a more permanent fix is published
  patches = [
    (fetchpatch {
      url = "https://github.com/johnbeard/kicad/commit/dfb1318a3989e3d6f9f2ac33c924ca5030ea273b.patch";
      sha256 = "00ifd3fas8lid8svzh1w67xc8kyx89qidp7gm633r014j3kjkgcd";
    })
  ];

  # tagged releases don't have "unknown"
  postPatch = optional (pname == "kicad-unstable")
  ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace "unknown" ${version}
    echo "replaced \"unknown\" with \"${version}\" in version name"
  '';

  makeFlags = optional (debug) [ "CFLAGS+=-Og" "CFLAGS+=-ggdb" ];

  cmakeFlags =
    optionals (scriptingSupport) [
      "-DKICAD_SCRIPTING=ON"
      "-DKICAD_SCRIPTING_MODULES=ON"
      "-DKICAD_SCRIPTING_PYTHON3=ON"
      "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
    ]
    ++ optional (!scriptingSupport)
      "-DKICAD_SCRIPTING=OFF"
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON"
    ++ optionals (withOCE)
      [ "-DKICAD_USE_OCE=ON" "-DOCE_DIR=${opencascade}" ]
    ++ optionals (withOCC) [
      "-DKICAD_USE_OCC=ON"
      # this line is redundant on unstable...
      # maybe may be removed on a later release
      "-DKICAD_USE_OCE=OFF"
      "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    ]
    ++ optionals (debug) [
      "-DCMAKE_BUILD_TYPE=Debug"
      "-DKICAD_STDLIB_DEBUG=ON"
      "-DKICAD_USE_VALGRIND=ON"
    ]
    ;

  pythonPath =
    optionals (scriptingSupport)
    [ wxPython pythonPackages.six ];

  nativeBuildInputs =
    [ cmake doxygen pkgconfig lndir ]
    ++ optionals (scriptingSupport)
      [ pythonPackages.wrapPython makeWrapper ]
  ;

  buildInputs = [
    libGLU libGL zlib libX11 wxGTK pcre libXdmcp gettext
    glew glm libpthreadstubs cairo curl openssl boost
  ]
  ++ optionals (scriptingSupport) [ swig python wxPython ]
  ++ optional (ngspiceSupport) libngspice
  ++ optional (withOCE) opencascade
  ++ optional (withOCC) opencascade-occt
  ++ optional (debug) valgrind
  ;

  # debug builds fail all but the python test
  # 5.1.x fails the eeschema test
  doInstallCheck = !debug && (pname == "kicad-unstable");
  installCheckTarget = "test";

  dontStrip = debug;

  postInstall = ''
    mkdir -p $out/share
    lndir ${kicad-libraries.i18n}/share $out/share
  '';

  makeWrapperArgs = [
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

  # can't add $out stuff to makeWrapperArgs...
  # wrapGAppsHook added the $out/share, though i noticed no difference without it
  preFixup =
    optionalString (scriptingSupport) '' buildPythonPath "$out $pythonPath"
    '' +
    '' wrapProgram $out/bin/kicad $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/pcbnew $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/eeschema $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/gerbview $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/pcb_calculator $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/pl_editor $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/bitmap2component $makeWrapperArgs ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    ''
  ;

  meta = {
    description = if (pname != "kicad-unstable")
      then "Open Source Electronics Design Automation Suite"
      else "Open Source EDA Suite, Development Build";
    homepage = "https://www.kicad-pcb.org/";
    longDescription = ''
      KiCad is an open source software suite for Electronic Design Automation.
      The Programs handle Schematic Capture, and PCB Layout with Gerber output.
    '';
    license = licenses.agpl3;
    maintainers = with maintainers; [ evils kiwi berce ];
    platforms = with platforms; linux;
  };
}
