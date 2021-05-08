{stdenv, lib, fetchgit, autoconf, automake, qt5, libtool, cmake, autoreconfHook, openblas, symlinkJoin}: pkg:
let 
  inherit (builtins) hasAttr getAttr length;
  inherit (lib) attrByPath concatStringsSep;

  getAttrDef = attr: default: x: attrByPath [attr] default x;
  myAppendAttr = attr: sep: x: if hasAttr attr x then sep + (getAttr attr x) else "";

  ifNoDeps = def: x:
    if length pkg.omdeps == 0 then def else x;

  joinedDeps = symlinkJoin {
    name = pkg.pname + "-omhome";
    paths = pkg.omdeps;
  };

  omautoconf = getAttrDef "omautoconf" false pkg;


  omtarget = getAttrDef "omtarget" pkg.pname pkg;

  omdir = getAttrDef "omdir" pkg.pname pkg;

  deptargets = lib.forEach pkg.omdeps (dep: dep.omtarget);

  configureFlags = ifNoDeps "" "--with-openmodelicahome=${joinedDeps} " +
    "--with-ombuilddir=$OMBUILDDIR " +
    "--prefix=$prefix " +
    myAppendAttr "configureFlags" " " pkg;

  preBuildPhases = ifNoDeps "" "skipTargetsPhase " +
    myAppendAttr "preBuildPhases" " " pkg;

in stdenv.mkDerivation (pkg // {
  inherit omtarget configureFlags preBuildPhases;

  src = fetchgit (import ./src-main.nix);
  version = "1.17.0";

  nativeBuildInputs = pkg.nativeBuildInputs ++ [autoconf automake libtool cmake
  qt5.qmake qt5.qttools autoreconfHook];
  buildInputs = pkg.buildInputs ++ [joinedDeps];

  #patch -p1 < ${./configure.ac.patch}
  patchPhase = ''
      sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qt5.qttools}/bin/lrelease|'
      sed -i OMPlot/Makefile.in -e 's|bindir = @includedir@|includedir = @includedir@|'
      sed -i OMPlot/OMPlot/OMPlotGUI/*.pro -e '/INCLUDEPATH +=/s|$| ../../qwt/src|'
    '' + ifNoDeps "" '' 
      
      sed -i ''$(find -name omhome.m4) -e 's|if test ! -z "$USINGPRESETBUILDDIR"|if test ! -z "$USINGPRESETBUILDDIR" -a -z "$OMHOME"|'
    '' +
    myAppendAttr "patchPhase" "\n" pkg;

  preAutoreconf = "patchShebangs --build" +
    myAppendAttr "preAutoreconf" "\n" pkg;

  dontUseCmakeConfigure = true;
  dontUseQmakeConfigure = true;

  configurePhase = "export OMBUILDDIR=$PWD/build; ./configure --no-recursion ${configureFlags}; " +
    (if omautoconf then " (cd ${omdir}; ./configure ${configureFlags})" else "");

  enableParallelBuilding = false;

  hardeningDisable = ["format"];

  skipTargetsPhase = ''
    for target in ${concatStringsSep " " deptargets}; do
      touch ''${target}.skip;
    done
  '';

  makeFlags = "${omtarget}" +
    myAppendAttr "makeFlags" " " pkg;

  installFlags = "-i " +
    myAppendAttr "installFlags" " " pkg;

  bowlup = ''
    unpackPhase
    cd OpenModelica-08fd3f9
    eval "$patchPhase"
    autoreconfPhase
    configurePhase
  '';
  
  meta = with lib; {
    description = "An open-source Modelica-based modeling and simulation environment";
    homepage    = "https://openmodelica.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.linux;
  };

})
