{stdenv, lib, fetchgit, gnumake, qt5, openblas, symlinkJoin}: pkg:
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

  omtarget = getAttrDef "omtarget" pkg.pname pkg;

  deptargets = lib.forEach pkg.omdeps (dep: dep.omtarget);

in stdenv.mkDerivation (pkg // {
  src = fetchgit (import ./src-main.nix);
  version = "1.17.0";

  nativeBuildInputs = pkg.nativeBuildInputs ++ [qt5.qmake qt5.qttools];
  buildInputs = pkg.buildInputs ++ [joinedDeps];

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

  enableParallelBuilding = false;

  hardeningDisable = ["format"];

  omtarget = omtarget;
  makeFlags = "${omtarget}" +
    myAppendAttr "makeFlags" " " pkg;

  installFlags = "-i " +
    myAppendAttr "installFlags" " " pkg;

  postFixup = ''
    for e in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$e \
        --prefix PATH : "${gnumake}/bin" \
        --prefix LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ openblas ]}"
    done
  '' + myAppendAttr "postFixup" "\n" pkg;

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

} // ifNoDeps {} {
  configureFlags = "--with-openmodelicahome=${joinedDeps}" +
    myAppendAttr "configureFlags" " " pkg;

  preBuildPhases = "skipTargetsPhase " +
    myAppendAttr "prebuildPhases" " " pkg;

  skipTargetsPhase = ''
    for target in ${concatStringsSep " " deptargets}; do
      touch ''${target}.skip;
    done
  '';
})
