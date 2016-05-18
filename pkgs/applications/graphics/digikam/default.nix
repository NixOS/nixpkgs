{ stdenv, fetchurl, automoc4, boost, shared_desktop_ontologies, cmake
, eigen, lcms, gettext, jasper, kdelibs, kdepimlibs, lensfun
, libgphoto2, libjpeg, libkdcraw, libkexiv2, libkipi, libpgf, libtiff
, libusb1, liblqr1, marble, mysql, opencv, perl, phonon, pkgconfig
, qca2, qimageblitz, qjson, qt4, soprano

# Optional build time dependencies
, baloo, doxygen, kfilemetadata
, lcms2
, kfaceSupport ? true, libkface ? null
, kgeomapSupport ? true, libkgeomap ? null
, libxslt

# Plugins optional build time dependencies
, gdk_pixbuf, imagemagick
, libgpod, libksane, libkvkontakte
, qt_gstreamer1 /*qt_soap, <https://github.com/commontk/QtSOAP>  herqq <http://www.herqq.org> -> is missing its av part.*/
  /*qt_koauth <http://gitorious.org/kqoauth>*/

# Supplementary packages required only by the wrapper.
, bash, kde_runtime, kde_baseapps, makeWrapper, oxygen_icons
, phonon-backend-vlc /*phonon-backend-gstreamer,*/
, ffmpegthumbs /*mplayerthumbs*/
, runCommand, shared_mime_info, writeScriptBin
}:

let 
  version = "4.12.0";
  pName = "digikam-${version}";

  build = stdenv.mkDerivation rec {
    name = "digikam-build-${version}";

    src = fetchurl {
      url = "http://download.kde.org/stable/digikam/${pName}.tar.bz2";
      sha256 = "081ldsaf3frf5khznjd3sxkjmi4dyp6w6nqnc2a0agkk0kxkl10m";
    };

    nativeBuildInputs = [ 
      automoc4 cmake gettext perl pkgconfig
    ] ++ [
      # Optional
      doxygen 
    ];

    buildInputs = [
      boost eigen jasper kdelibs kdepimlibs lcms lensfun
      libgphoto2 libjpeg libkdcraw libkexiv2 libkipi liblqr1 libpgf
      libtiff marble mysql.lib opencv phonon qca2 qimageblitz qjson qt4
      shared_desktop_ontologies soprano ]
    # Optional build time dependencies
    ++ [
      baloo 
      kfilemetadata 
      lcms2 ] 
    ++ stdenv.lib.optional (kfaceSupport && null != libkface) [ libkface ]
    ++ stdenv.lib.optional (kgeomapSupport && null != libkgeomap) [ libkgeomap ] ++ 
    [ libxslt ]
    # Plugins optional build time dependencies
    ++ [
      gdk_pixbuf imagemagick libgpod libksane
      libkvkontakte
      qt_gstreamer1 ];

    # Make digikam find some FindXXXX.cmake
    KDEDIRS="${marble}:${qjson}";

    # Find kdepimlibs's upper case headers under `include/KDE`.
    NIX_CFLAGS_COMPILE = "-I${kdepimlibs}/include/KDE";

    # Help digiKam find libusb, otherwise gphoto2 support is disabled
    cmakeFlags = [
      "-DLIBUSB_LIBRARIES=${libusb1.out}/lib"
      "-DLIBUSB_INCLUDE_DIR=${libusb1}/include/libusb-1.0"
      "-DENABLE_BALOOSUPPORT=ON"
      "-DENABLE_KDEPIMLIBSSUPPORT=ON"
      "-DENABLE_LCMS2=ON" ] 
    ++ stdenv.lib.optional (kfaceSupport && null == libkface) [ "-DDIGIKAMSC_COMPILE_LIBKFACE=ON" ]
    ++ stdenv.lib.optional (kgeomapSupport && null == libkgeomap) [ "-DDIGIKAMSC_COMPILE_LIBKGEOMAP=ON" ];

    enableParallelBuilding = true;

    meta = {
      description = "Photo Management Program";
      license = stdenv.lib.licenses.gpl2;
      homepage = http://www.digikam.org;
      maintainers = with stdenv.lib.maintainers; [ goibhniu viric urkud ];
      inherit (kdelibs.meta) platforms;
    };
  };


  kdePkgs = [
    build # digikam's own build
    kdelibs kdepimlibs kde_runtime kde_baseapps libkdcraw oxygen_icons
    /*phonon-backend-gstreamer*/ phonon-backend-vlc
    ffmpegthumbs /*mplayerthumbs*/ shared_mime_info ]
  # Optional build time dependencies
  ++ [

    baloo kfilemetadata ] 
  ++ stdenv.lib.optional (kfaceSupport && null != libkface) [ libkface ]
  ++ stdenv.lib.optional (kgeomapSupport && null != libkgeomap) [ libkgeomap ] 
  ++ [ 
    libkipi ] 
  # Plugins optional build time dependencies
  ++ [
    libksane libkvkontakte
  ];


  # TODO: It should be the responsability of these packages to add themselves to `KDEDIRS`. See
  # <https://github.com/ttuegel/nixpkgs/commit/a0efeacc0ef2cf63bbb768bfb172a483307d080b> for
  # a practical example.
  # IMPORTANT: Note that using `XDG_DATA_DIRS` here instead of `KDEDIRS` won't work properly.
  KDEDIRS = with stdenv.lib; concatStrings (intersperse ":" (map (x: "${x}") kdePkgs));

  sycocaDirRelPath = "var/lib/kdesycoca";
  sycocaFileRelPath = "${sycocaDirRelPath}/${pName}.sycoca";

  sycoca = runCommand "${pName}" {

    name = "digikam-sycoca-${version}";

    nativeBuildInputs = [ kdelibs ];

    dontPatchELF = true;
    dontStrip = true;

  } ''
    # Make sure kbuildsycoca4 does not attempt to write to user home directory.
    export HOME=$PWD

    export KDESYCOCA="$out/${sycocaFileRelPath}"

    mkdir -p $out/${sycocaDirRelPath}
    export XDG_DATA_DIRS=""
    export KDEDIRS="${KDEDIRS}"
    kbuildsycoca4 --noincremental --nosignal
  '';


  replaceExeListWithWrapped = 
    let f = exeName: ''
        rm -f "$out/bin/${exeName}"
        makeWrapper "${build}/bin/${exeName}" "$out/bin/${exeName}" \
          --set XDG_DATA_DIRS "" \
          --set KDEDIRS "${KDEDIRS}" \
          --set KDESYCOCA "${sycoca}/${sycocaFileRelPath}"
      '';
    in 
      with stdenv.lib; exeNameList: concatStrings (intersperse "\n" (map f exeNameList));

in


with stdenv.lib;

/*
  Final derivation
  ----------------

   -  Create symlinks to our original build derivation items.
   -  Wrap specific executables so that they know of the appropriate
      sycoca database, `KDEDIRS` to use and block any interference
      from `XDG_DATA_DIRS` (only `dnginfo` is not wrapped).
*/
runCommand "${pName}" {
  inherit build;
  inherit sycoca;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = kdePkgs;

  dontPatchELF = true;
  dontStrip = true;

  meta = {
    description = "Photo Management Program";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ /*jraygauthier*/ ];
    inherit (kdelibs.meta) platforms;
  };

} ''
  pushd $build > /dev/null
  for d in `find . -maxdepth 1 -name "*" -printf "%f\n" | tail -n+2`; do
    mkdir -p $out/$d
    for f in `find $d -maxdepth 1 -name "*" -printf "%f\n" | tail -n+2`; do
        ln -s "$build/$d/$f" "$out/$d/$f"
    done
  done
  popd > /dev/null
  
  ${replaceExeListWithWrapped [ "cleanup_digikamdb" "digitaglinktree" "digikam" "dngconverter" 
                                "expoblending" "photolayoutseditor" "scangui" "showfoto" ]}
''

/*
  
TODO
----

### Useful ###

 -  Per lib `KDELIBS` environment variable export. See above in-code TODO comment.
 -  Missing optional `qt_soap` or `herqq` (av + normal package) dependencies. Those are not
    yet (or not fully) packaged in nix. Mainly required for upnp export.
 -  Possibility to use the `phonon-backend-gstreamer` with its own user specified set of backend.
 -  Allow user to disable optional features or dependencies reacting properly.
 -  Compile `kipiplugins` as a separate package (so that it can be used by other kde packages
    and so that this package's build time is reduced).

### Not so useful ###

 -  Missing optional `qt_koauth` (not packaged in nix).
 -  Missing optional `libmediawiki` (not packaged in nix)..
 -  For some reason the cmake build does not detect `libkvkontakte`. Fix this.
 -  Possibility to use `mplayerthumbs` thumbnail creator backend. In digikam dev docs,
    it is however suggested to use `ffmpegthumbs`. Maybe we should stick to it.

*/
