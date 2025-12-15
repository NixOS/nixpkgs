# Version string functions.
{ lib }:

rec {

  /**
    Break a version string into its component parts.

    # Examples
    :::{.example}
    ## `splitVersion` usage example

    ```nix
    splitVersion "1.2.3"
    => ["1" "2" "3"]
    ```

    :::
  */
  splitVersion = builtins.splitVersion;

  /**
    Get the major version string from a string.

    # Inputs

    `v`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `major` usage example

    ```nix
    major "1.2.3"
    => "1"
    ```

    :::
  */
  major = v: builtins.elemAt (splitVersion v) 0;

  /**
    Get the minor version string from a string.

    # Inputs

    `v`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `minor` usage example

    ```nix
    minor "1.2.3"
    => "2"
    ```

    :::
  */
  minor = v: builtins.elemAt (splitVersion v) 1;

  /**
    Get the patch version string from a string.

    # Inputs

    `v`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `patch` usage example

    ```nix
    patch "1.2.3"
    => "3"
    ```

    :::
  */
  patch = v: builtins.elemAt (splitVersion v) 2;

  /**
    Get string of the first two parts (major and minor)
    of a version string.

    # Inputs

    `v`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `majorMinor` usage example

    ```nix
    majorMinor "1.2.3"
    => "1.2"
    ```

    :::
  */
  majorMinor = v: builtins.concatStringsSep "." (lib.take 2 (splitVersion v));

  /**
    Pad a version string with zeros to match the given number of components.

    # Inputs

    `n`

    : 1\. Function argument

    `version`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `pad` usage example

    ```nix
    pad 3 "1.2"
    => "1.2.0"
    pad 3 "1.3-rc1"
    => "1.3.0-rc1"
    pad 3 "1.2.3.4"
    => "1.2.3"
    ```

    :::
  */
  pad =
    n: version:
    let
      numericVersion = lib.head (lib.splitString "-" version);
      versionSuffix = lib.removePrefix numericVersion version;
    in
    lib.concatStringsSep "." (lib.take n (lib.splitVersion numericVersion ++ lib.genList (_: "0") n))
    + versionSuffix;

}
