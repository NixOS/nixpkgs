{ fetchurl }:

{ pname, version, ... }@attrs:
{
  inherit pname version;
  src = fetchurl (
    {
      name = "dub-${pname}-${version}.zip";
      url = "mirror://dub/${pname}/${version}.zip";
    }
    // builtins.removeAttrs attrs [
      "pname"
      "version"
    ]
  );
}
