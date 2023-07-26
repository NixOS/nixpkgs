# Generators {#sec-generators}
Generators are functions that create file formats from nix data structures, e. g. for configuration files. There are generators available for: `INI`, `JSON` and `YAML`

All generators follow a similar call interface: `generatorName configFunctions data`, where `configFunctions` is an attrset of user-defined functions that format nested parts of the content. They each have common defaults, so often they do not need to be set manually. An example is `mkSectionName ? (name: libStr.escape [ "[" "]" ] name)` from the `INI` generator. It receives the name of a section and sanitizes it. The default `mkSectionName` escapes `[` and `]` with a backslash.

Generators can be fine-tuned to produce exactly the file format required by your application/service. One example is an INI-file format which uses `: ` as separator, the strings `"yes"`/`"no"` as boolean values and requires all string values to be quoted:

```nix
with lib;
let
  customToINI = generators.toINI {
    # specifies how to format a key/value pair
    mkKeyValue = generators.mkKeyValueDefault {
      # specifies the generated string for a subset of nix values
      mkValueString = v:
             if v == true then ''"yes"''
        else if v == false then ''"no"''
        else if isString v then ''"${v}"''
        # and delegates all other values to the default generator
        else generators.mkValueStringDefault {} v;
    } ":";
  };

# the INI file can now be given as plain old nix values
in customToINI {
  main = {
    pushinfo = true;
    autopush = false;
    host = "localhost";
    port = 42;
  };
  mergetool = {
    merge = "diff3";
  };
}
```

This will produce the following INI file as nix string:

```INI
[main]
autopush:"no"
host:"localhost"
port:42
pushinfo:"yes"
str\:ange:"very::strange"

[mergetool]
merge:"diff3"
```

::: {.note}
Nix store paths can be converted to strings by enclosing a derivation attribute like so: `"${drv}"`.
:::

Detailed documentation for each generator can be found in `lib/generators.nix`.
