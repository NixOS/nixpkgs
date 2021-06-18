{ lib }:
with lib;
rec {
  runtimeDir = "/run/httpd";

  configParser = config:
    if isAttrs config then
      concatStringsSep "\n" (mapAttrsToList (name: value:
        if isString value then
          "${name} ${value}"
        else if isInt value then
          "${name} ${toString value}"
        else if isStorePath value then
          "${name} ${toString value}"
        else if isList value then
          if all (x: isString x) value then
            "${name} ${concatStringsSep " " value}"
          else if all (x: isInt x) value then
            "${name} ${concatStringsSep " " (toString value)}"
          else if all (x: isStorePath x) value then
            "${name} ${concatStringsSep " " (toString value)}"
          else if all (x: isList x) value then
            concatStringsSep "\n"
              (map (p: "${name} ${concatStringsSep " " p}") value)
          else
            abort "Unsupported type in ApacheHTTPD configuration attrset, the module system should have caught this!"
        else if isAttrs value then
          concatStringsSep "\n" (mapAttrsToList (an: av:
            ''
              <${name} ${an}>
                ${configParser av}
              </${name}>
            '') value)
        else
          abort "Unsupported type in ApacheHTTPD configuration attrset, the module system should have caught this!"
      ) config)
    else if isList config then
      concatMapStringsSep "\n" (x:
        if isAttrs x then
          configParser x
        else if isString x then
          x
        else
          abort "Unsupported type in ApacheHTTPD configuration attrset, the module system should have caught this!"
      ) config
    else
      abort "Unsupported type in ApacheHTTPD configuration attrset, the module system should have caught this!";
}
