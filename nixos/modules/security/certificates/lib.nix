# Helper functions for use around the security.certificates module
{ lib, pkgs }:
let
  inherit (lib)
    any
    concatStringsSep
    imap1
    isList
    listToAttrs
    mapAttrsToList
    mergeAttrsList
    pipe
    ;
in
{
  openssl = rec {
    /**
      OpenSSL multi-value short form
      Converts a list of values to a comma seperated list, aborts if any item
      in the list contains a comma "," as this will break a OpenSSL config file

      # Inputs
      `list`
      : List of strings to be merged

      # Type
      ```
      toMultiValueShort :: [string] -> string
      ```
    */
    toMultiValShort =
      list:
      if any (lib.hasInfix ",") list then
        abort "toMultiValShort called with a string containing ','"
      else
        concatStringsSep "," list;

    /**
      OpenSSL multi-value long form

      Takes a name prefix and lsit of strings and converts it into a attrset of
      prefixed, numbered attributes as expected by OpenSSL.

      # Inputs
      `name`
      : Prefix string

      `list`
      : List of string values to be assigned to attributes

      # Type
      ```
      toMultiValueLong :: string -> [string] -> AttrSet
      ```
    */
    toMultiValLong =
      name: list:
      listToAttrs (
        imap1
          (i: val: {
            name = "${name}.${toString i}";
            value = toString val;
          })
          list
      );

    /**
      OpenSSL multi-value section

      Takes a attribute set of strings and/or lists of strings and converts them
      to long form multi-values

      # Inputs
      `attrs`
      : Attribute set to transform

      # Type
      ```
      toMultiVals :: AttrSet -> AttrSet
      ```
    */
    toMultiVals =
      attrs:
      pipe attrs [
        (mapAttrsToList (
          name: value: if (isList value) then (toMultiValLong name value) else { ${name} = value; }
        ))
        mergeAttrsList
      ];

    /**
      OpenSSL config file generator

      Generate a INI style OpenSSL config file from a attrset. Converts lists to
      shortform multi-values.
      ::: {.warn}
      If any lists contain values containing commas they will fail when
      converted to multi-values. They must manually be converted using
      toMultiValLong
      :::

      # Type
      ```
      config :: { type, generate }
      ```
    */
    config =
      let
        inherit (lib.generators)
          mkKeyValueDefault
          mkValueStringDefault;
      in
      pkgs.formats.ini {
        mkKeyValue = mkKeyValueDefault
          {
            mkValueString =
              v:
              if (lib.isList v) then
                toMultiValShort (map (mkValueStringDefault { }) v)
              else
                mkValueStringDefault { } v;
          } "=";
      };
    /**
      OpenSSL shell command

      Convert a OpenSSL command and attrset of arguments to a openssl shell
      command line.

      # Inputs
      cmd
      : OpenSSL command
      attrs
      : command line arguments

      # Type
      ```
      toShell :: string -> AttrSet -> string
      ```
    */
    toShell =
      cmd: args: "openssl ${cmd} ${lib.cli.toGNUCommandLineShell { mkOptionName = k: "-${k}"; } args}";
  };
}
