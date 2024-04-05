{ pname
, version
, src
, meta
, appimageTools
}:
appimageTools.wrapType2 rec {
  inherit pname version src meta;
  name = "${pname}-${version}";

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
  '';
}
