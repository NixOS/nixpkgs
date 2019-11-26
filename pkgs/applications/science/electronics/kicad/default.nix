{ lib, stdenv, fetchFromGitHub, cmake, libGLU, libGL, zlib, wxGTK
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp, makeWrapper, gnome3
, gsettings-desktop-schemas, librsvg, hicolor-icon-theme, lndir, cups
, fetchpatch

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
  mkLib = version: name: sha256: attrs: stdenv.mkDerivation ({
    name = "kicad-${name}-${version}";
    src = fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-${name}";
      rev = version;
      inherit sha256 name;
    };
    nativeBuildInputs = [ cmake ];
  } // attrs);

  # oce on aarch64 fails a test
  withOCC = (stdenv.isAarch64 && (withOCCT || oceSupport)) || (!stdenv.isAarch64 && withOCCT);
  withOCE = oceSupport && !stdenv.isAarch64 && !withOCC;

in
stdenv.mkDerivation rec {
  pname = "kicad";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "KiCad";
    repo = "kicad-source-mirror";
    rev = version;
    sha256 = "15h3rwisjss3fdc9bam9n2wq94slhacc3fbg14bnzf4n5agsnv5b";
  };

  # quick fix for #72248
  # should be removed if a better fix is merged
  patches = [
    (fetchpatch {
      url = "https://github.com/johnbeard/kicad/commit/dfb1318a3989e3d6f9f2ac33c924ca5030ea273b.patch";
      sha256 = "00ifd3fas8lid8svzh1w67xc8kyx89qidp7gm633r014j3kjkgcd";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace "unknown" ${version}
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
      # this line is unneeded on unstable...
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

  # 5.1.x fails the eeschema test
  # doInstallCheck = (!debug);
  # installCheckTarget = "test";

  dontStrip = debug;

  passthru = {
    symbols = mkLib "${version}" "symbols" "048b07ffsaav1ssrchw2p870lvb4rsyb5vnniy670k7q9p16qq6h" {
      meta.license = licenses.cc-by-sa-40;
    };
    templates = mkLib "${version}" "templates" "0cs3bm3zb5ngw5ldn0lzw5bvqm4kvcidyrn76438alffwiz2b15g" {
      meta.license = licenses.cc-by-sa-40;
    };
    footprints = mkLib "${version}" "footprints" "1c4whgn14qhz4yqkl46w13p6rpv1k0hsc9s9h9368fxfcz9knb2j" {
      meta.license = licenses.cc-by-sa-40;
    };
    i18n = mkLib "${version}" "i18n" "1rfpifl8vky1gba2angizlb2n7mwmsiai3r6ip6qma60wdj8sbd3" {
      buildInputs = [ gettext ];
      meta.license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
    };
    packages3d = mkLib "${version}" "packages3d" "0cff2ms1bsw530kqb1fr1m2pjixyxzwa81mxgac3qpbcf8fnpvaz" {
      hydraPlatforms = []; # this is a ~1 GiB download, occupies ~5 GiB in store
      meta.license = licenses.cc-by-sa-40;
    };
  };

  # TODO, figure out how to skip this step? (since we're not making the 3D models optional)
  modules = with passthru; [ i18n symbols footprints templates ]
  ++ optionals (with3d) [ packages3d ];

  postInstall = ''
    mkdir -p $out/share
    for module in $modules; do
      lndir $module/share $out/share
    done
  '';

  makeWrapperArgs = [
    "--prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share"
    "--prefix XDG_DATA_DIRS : ${gnome3.defaultIconTheme}/share"
    "--prefix XDG_DATA_DIRS : ${wxGTK.gtk}/share/gsettings-schemas/${wxGTK.gtk.name}"
    "--prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    # wrapGAppsHook did these, as well, no idea if it matters...
    "--prefix XDG_DATA_DIRS : ${cups}/share"
    "--prefix GIO_EXTRA_MODULES : ${gnome3.dconf}/lib/gio/modules"
  ]
  ++ optionals (ngspiceSupport) [ "--prefix LD_LIBRARY_PATH : ${libngspice}/lib" ]
  # infinisil's workaround for #39493
  ++ [ "--set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]
  ;

  # can't add $out stuff to makeWrapperArgs...
  # wrapGAppsHook added the $out/share, though i noticed no difference without it
  preFixup =
    optionalString (scriptingSupport) '' buildPythonPath "$out $pythonPath"
    '' +
    '' wrapProgram $out/bin/kicad $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share --set KICAD_SYMBOL_DIR $out/share/kicad/library --set KICAD_TEMPLATE_DIR $out/share/kicad/template --set KISYS3DMOD $out/share/kicad/modules/packages3d --set KISYSMOD $out/share/kicad/modules ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/pcbnew $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share --set KISYS3DMOD $out/share/kicad/modules/packages3d ''
    + optionalString (scriptingSupport) '' --set PYTHONPATH "$program_PYTHONPATH"
    '' +
    '' wrapProgram $out/bin/eeschema $makeWrapperArgs --prefix XDG_DATA_DIRS : $out/share --set KICAD_SYMBOL_DIR $out/share/kicad/library ''
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
    description = "Free Software EDA Suite";
    homepage = "http://www.kicad-pcb.org/";
    license = with licenses; [ gpl2 cc-by-sa-40 ];
    maintainers = with maintainers; [ evils kiwi berce ];
    platforms = with platforms; linux;
  };
}
