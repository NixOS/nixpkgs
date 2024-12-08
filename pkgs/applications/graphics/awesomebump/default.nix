{ mkDerivation, lib, fetchgit, qtbase, qmake, qtscript, flex, bison, qtdeclarative }:


let
  version = "5.1";

  src = fetchgit {
    url = "https://github.com/kmkolasinski/AwesomeBump.git";
    rev = "Winx32v${version}";
    sha256 = "1c8b9jki0v8kzkvsvyv7q1w3s7j40br6ph15hh2xi0a1mpwckq56";
    fetchSubmodules = true;
  };

  qtnproperty = mkDerivation {
    name = "qtnproperty";
    inherit src;
    sourceRoot = "${src.name}/Sources/utils/QtnProperty";
    patches = [ ./qtnproperty-parallel-building.patch ];
    buildInputs = [ qtscript qtbase qtdeclarative ];
    nativeBuildInputs = [ qmake flex bison ];
    postInstall = ''
      install -D bin-linux/QtnPEG $out/bin/QtnPEG
    '';
  };
in mkDerivation {
  pname = "awesomebump";
  inherit version;

  inherit src;

  buildInputs = [ qtbase qtscript qtdeclarative ];

  nativeBuildInputs = [ qmake ];

  preBuild = ''
    ln -sf ${qtnproperty}/bin/QtnPEG Sources/utils/QtnProperty/bin-linux/QtnPEG
  '';

  dontWrapQtApps = true;
  postInstall = ''
    d=$out/libexec/AwesomeBump

    mkdir -p $d
    cp -vr workdir/`cat workdir/current`/bin/AwesomeBump $d/
    cp -prd Bin/Configs Bin/Core $d/

    # AwesomeBump expects to find Core and Configs in its current directory.
    makeQtWrapper $d/AwesomeBump $out/bin/AwesomeBump \
        --chdir "$d"
  '';

  # $ cd Sources; qmake; make ../workdir/linux-g++-dgb-gl4/obj/glwidget.o
  # fatal error: properties/ImageProperties.peg.h: No such file or directory
  enableParallelBuilding = false;

  meta = {
    homepage = "https://github.com/kmkolasinski/AwesomeBump";
    description = "Program to generate normal, height, specular or ambient occlusion textures from a single image";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "AwesomeBump";
  };
}
