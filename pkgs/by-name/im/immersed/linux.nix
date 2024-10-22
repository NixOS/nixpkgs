{ pname
, version
, src
, meta
, appimageTools
}:
appimageTools.wrapType2 {
  inherit pname version src meta;
}
