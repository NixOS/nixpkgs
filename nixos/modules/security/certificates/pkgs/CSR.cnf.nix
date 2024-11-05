{
  writeText,
  lib,
  specification
}:
let
  inherit (lib) 
    concatMapAttrs
    mapAttrs
    mkMerge
    isAttrs
    isStringLike;
  ini = mkMerge [
    {
      req = {
        prompt = "no";
        distinguished_name = "req_distinguishedName";
        req_extensions = "req_extensions";
      };

      # Distinguished Name (Subject)
      req_distinguishedName = specification.subject;

      # Extensions
      req_extensions = mapAttrs
        (n: v:
          if isStringLike v then (toString v)
          else if isAttrs v && (v ? _value) then
            (
              if v.critical or true
              then "critical, ${v._value}"
              else v._value
            )
          else abort "Cannot convert extension ${n} to string")
        specification.extensions;
    }
    # Collect extra sections from extensions
    (concatMapAttrs
      (_: v:
        if isAttrs v
        then v._extraSections or { }
        else { })
      specification.extensions)
  ];
in
  writeText 
    "certificate-${specification.name}.csr.cnf"
    ((import ../lib.nix) { inherit lib; } ini)