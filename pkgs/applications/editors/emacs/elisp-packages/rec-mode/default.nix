{ lib
, trivialBuild
, recutils
}:

trivialBuild {
  pname = "rec-mode";

  inherit (recutils) version src;

  postUnpack = ''
    sourceRoot="$sourceRoot/etc"
  '';

  meta = recutils.meta // {
    description = "A major mode for editing rec files";
  };
}
