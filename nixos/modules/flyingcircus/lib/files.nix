{ lib, fclib, ... }: with lib;

{

  files = path:
    (map
      (filename: path + "/" + filename)
      (attrNames
        (filterAttrs
          (filename: type: (type == "regular"))
          (builtins.readDir path))));

}
