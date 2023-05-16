<<<<<<< HEAD
{ appimageTools
, lib
, fetchurl
}:
let
  pname = "nuclear";
  version = "0.6.30";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/v${version}/${pname}-v${version}.AppImage";
    hash = "sha256-he1uGC1M/nFcKpMM9JKY4oeexJcnzV0ZRxhTjtJz6xw=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
=======
{ appimageTools, lib, fetchurl }:
let
  pname = "nuclear";
  version = "0.6.6";
  name = "${pname}-v${version}";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/v${version}/${name}.AppImage";
    sha256 = "0c1335m76fv0wfbk07s8r6ln7zbmlqd66052gqfisakl8a1aafl6";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
<<<<<<< HEAD

    # unless linked, the binary is placed in $out/bin/nuclear-someVersion
    # link it to $out/bin/nuclear
    ln -s $out/bin/${pname}-${version} $out/bin/${pname}
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclear.js.org/";
    license = licenses.agpl3Plus;
<<<<<<< HEAD
    maintainers = [ maintainers.NotAShelf ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuclear";
=======
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
