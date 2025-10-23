/**
  Some functions for manipulating meta attributes, as well as the
  name attribute.
*/

{ lib }:

let
  inherit (lib)
    matchAttrs
    any
    all
    isDerivation
    getBin
    assertMsg
    ;
  inherit (lib.attrsets) mapAttrs' filterAttrs;
  inherit (builtins)
    isString
    match
    typeOf
    elemAt
    ;

in
rec {

  /**
    Add to or override the meta attributes of the given
    derivation.

    # Inputs

    `newAttrs`

    : 1\. Function argument

    `drv`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.meta.addMetaAttrs` usage example

    ```nix
    addMetaAttrs {description = "Bla blah";} somePkg
    ```

    :::
  */
  addMetaAttrs =
    newAttrs: drv:
    if drv ? overrideAttrs then
      drv.overrideAttrs (old: {
        meta = (old.meta or { }) // newAttrs;
      })
    else
      drv // { meta = (drv.meta or { }) // newAttrs; };

  /**
    Disable Hydra builds of given derivation.

    # Inputs

    `drv`

    : 1\. Function argument
  */
  dontDistribute = drv: addMetaAttrs { hydraPlatforms = [ ]; } drv;

  /**
    Change the [symbolic name of a derivation](https://nixos.org/manual/nix/stable/language/derivations.html#attr-name).

    :::{.warning}
    Dependent derivations will be rebuilt when the symbolic name is changed.
    :::

    # Inputs

    `name`

    : 1\. Function argument

    `drv`

    : 2\. Function argument
  */
  setName = name: drv: drv // { inherit name; };

  /**
    Like `setName`, but takes the previous name as an argument.

    # Inputs

    `updater`

    : 1\. Function argument

    `drv`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.meta.updateName` usage example

    ```nix
    updateName (oldName: oldName + "-experimental") somePkg
    ```

    :::
  */
  updateName = updater: drv: drv // { name = updater (drv.name); };

  /**
    Append a suffix to the name of a package (before the version
    part).

    # Inputs

    `suffix`

    : 1\. Function argument
  */
  appendToName =
    suffix:
    updateName (
      name:
      let
        x = builtins.parseDrvName name;
      in
      "${x.name}-${suffix}-${x.version}"
    );

  /**
    Apply a function to each derivation and only to derivations in an attrset.

    # Inputs

    `f`

    : 1\. Function argument

    `set`

    : 2\. Function argument
  */
  mapDerivationAttrset =
    f: set: lib.mapAttrs (name: pkg: if lib.isDerivation pkg then (f pkg) else pkg) set;

  /**
    The default priority of packages in Nix. See `defaultPriority` in [`src/nix/profile.cc`](https://github.com/NixOS/nix/blob/master/src/nix/profile.cc#L47).
  */
  defaultPriority = 5;

  /**
    Set the nix-env priority of the package. Note that higher values are lower priority, and vice versa.

    # Inputs

    `priority`
    : 1\. The priority to set.

    `drv`
    : 2\. Function argument
  */
  setPrio = priority: addMetaAttrs { inherit priority; };

  /**
    Decrease the nix-env priority of the package, i.e., other
    versions/variants of the package will be preferred.

    # Inputs

    `drv`

    : 1\. Function argument
  */
  lowPrio = setPrio 10;

  /**
    Apply lowPrio to an attrset with derivations.

    # Inputs

    `set`

    : 1\. Function argument
  */
  lowPrioSet = set: mapDerivationAttrset lowPrio set;

  /**
    Increase the nix-env priority of the package, i.e., this
    version/variant of the package will be preferred.

    # Inputs

    `drv`

    : 1\. Function argument
  */
  hiPrio = setPrio (-10);

  /**
    Apply hiPrio to an attrset with derivations.

    # Inputs

    `set`

    : 1\. Function argument
  */
  hiPrioSet = set: mapDerivationAttrset hiPrio set;

  /**
    Check to see if a platform is matched by the given `meta.platforms`
    element.

    A `meta.platform` pattern is either

    1. (legacy) a system string.

    2. (modern) a pattern for the entire platform structure (see `lib.systems.inspect.platformPatterns`).

    3. (modern) a pattern for the platform `parsed` field (see `lib.systems.inspect.patterns`).

    We can inject these into a pattern for the whole of a structured platform,
    and then match that.

    # Inputs

    `platform`

    : 1\. Function argument

    `elem`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.meta.platformMatch` usage example

    ```nix
    lib.meta.platformMatch { system = "aarch64-darwin"; } "aarch64-darwin"
    => true
    ```

    :::
  */
  platformMatch =
    platform: elem:
    (
      # Check with simple string comparison if elem was a string.
      #
      # The majority of comparisons done with this function will be against meta.platforms
      # which contains a simple platform string.
      #
      # Avoiding an attrset allocation results in significant  performance gains (~2-30) across the board in OfBorg
      # because this is a hot path for nixpkgs.
      if isString elem then
        platform ? system && elem == platform.system
      else
        matchAttrs (
          # Normalize platform attrset.
          if elem ? parsed then elem else { parsed = elem; }
        ) platform
    );

  /**
    Check if a package is available on a given platform.

    A package is available on a platform if both

    1. One of `meta.platforms` pattern matches the given
        platform, or `meta.platforms` is not present.

    2. None of `meta.badPlatforms` pattern matches the given platform.

    # Inputs

    `platform`

    : 1\. Function argument

    `pkg`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.meta.availableOn` usage example

    ```nix
    lib.meta.availableOn { system = "aarch64-darwin"; } pkg.zsh
    => true
    ```

    :::
  */
  availableOn =
    platform: pkg:
    ((!pkg ? meta.platforms) || any (platformMatch platform) pkg.meta.platforms)
    && all (elem: !platformMatch platform elem) (pkg.meta.badPlatforms or [ ]);

  /**
    Mapping of SPDX ID to the attributes in lib.licenses.

    For SPDX IDs, see https://spdx.org/licenses.
    Note that some SPDX licenses might be missing.

    # Examples
    :::{.example}
    ## `lib.meta.licensesSpdx` usage example

    ```nix
    lib.licensesSpdx.MIT == lib.licenses.mit
    => true
    lib.licensesSpdx."MY LICENSE"
    => error: attribute 'MY LICENSE' missing
    ```

    :::
  */
  licensesSpdx = mapAttrs' (_key: license: {
    name = license.spdxId;
    value = license;
  }) (filterAttrs (_key: license: license ? spdxId) lib.licenses);

  /**
    Get the corresponding attribute in lib.licenses from the SPDX ID
    or warn and fallback to `{ shortName = <license string>; }`.

    For SPDX IDs, see https://spdx.org/licenses.
    Note that some SPDX licenses might be missing.

    # Type

    ```
    getLicenseFromSpdxId :: str -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.meta.getLicenseFromSpdxId` usage example

    ```nix
    lib.getLicenseFromSpdxId "MIT" == lib.licenses.mit
    => true
    lib.getLicenseFromSpdxId "mIt" == lib.licenses.mit
    => true
    lib.getLicenseFromSpdxId "MY LICENSE"
    => trace: warning: getLicenseFromSpdxId: No license matches the given SPDX ID: MY LICENSE
    => { shortName = "MY LICENSE"; }
    ```

    :::
  */
  getLicenseFromSpdxId =
    licstr:
    getLicenseFromSpdxIdOr licstr (
      lib.warn "getLicenseFromSpdxId: No license matches the given SPDX ID: ${licstr}" {
        shortName = licstr;
      }
    );

  /**
    Get the corresponding attribute in lib.licenses from the SPDX ID
    or fallback to the given default value.

    For SPDX IDs, see https://spdx.org/licenses.
    Note that some SPDX licenses might be missing.

    # Inputs

    `licstr`
    : 1\. SPDX ID string to find a matching license

    `default`
    : 2\. Fallback value when a match is not found

    # Type

    ```
    getLicenseFromSpdxIdOr :: str -> Any -> Any
    ```

    # Examples
    :::{.example}
    ## `lib.meta.getLicenseFromSpdxIdOr` usage example

    ```nix
    lib.getLicenseFromSpdxIdOr "MIT" null == lib.licenses.mit
    => true
    lib.getLicenseFromSpdxId "mIt" null == lib.licenses.mit
    => true
    lib.getLicenseFromSpdxIdOr "MY LICENSE" lib.licenses.free == lib.licenses.free
    => true
    lib.getLicenseFromSpdxIdOr "MY LICENSE" null
    => null
    lib.getLicenseFromSpdxIdOr "MY LICENSE" (throw "No SPDX ID matches MY LICENSE")
    => error: No SPDX ID matches MY LICENSE
    ```
    :::
  */
  getLicenseFromSpdxIdOr =
    let
      lowercaseLicenses = lib.mapAttrs' (name: value: {
        name = lib.toLower name;
        inherit value;
      }) licensesSpdx;
    in
    licstr: default: lowercaseLicenses.${lib.toLower licstr} or default;

  /**
    Get the path to the main program of a package based on meta.mainProgram

    # Inputs

    `x`

    : 1\. Function argument

    # Type

    ```
    getExe :: package -> string
    ```

    # Examples
    :::{.example}
    ## `lib.meta.getExe` usage example

    ```nix
    getExe pkgs.hello
    => "/nix/store/g124820p9hlv4lj8qplzxw1c44dxaw1k-hello-2.12/bin/hello"
    getExe pkgs.mustache-go
    => "/nix/store/am9ml4f4ywvivxnkiaqwr0hyxka1xjsf-mustache-go-1.3.0/bin/mustache"
    ```

    :::
  */
  getExe =
    x:
    getExe' x (
      x.meta.mainProgram or (
        # This could be turned into an error when 23.05 is at end of life
        lib.warn
          "getExe: Package ${
            lib.strings.escapeNixIdentifier x.meta.name or x.pname or x.name
          } does not have the meta.mainProgram attribute. We'll assume that the main program has the same name for now, but this behavior is deprecated, because it leads to surprising errors when the assumption does not hold. If the package has a main program, please set `meta.mainProgram` in its definition to make this warning go away. Otherwise, if the package does not have a main program, or if you don't control its definition, use getExe' to specify the name to the program, such as lib.getExe' foo \"bar\"."
          lib.getName
          x
      )
    );

  /**
    Get the path of a program of a derivation.

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument

    # Type

    ```
    getExe' :: derivation -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.meta.getExe'` usage example

    ```nix
    getExe' pkgs.hello "hello"
    => "/nix/store/g124820p9hlv4lj8qplzxw1c44dxaw1k-hello-2.12/bin/hello"
    getExe' pkgs.imagemagick "convert"
    => "/nix/store/5rs48jamq7k6sal98ymj9l4k2bnwq515-imagemagick-7.1.1-15/bin/convert"
    ```

    :::
  */
  getExe' =
    x: y:
    assert assertMsg (isDerivation x)
      "lib.meta.getExe': The first argument is of type ${typeOf x}, but it should be a derivation instead.";
    assert assertMsg (isString y)
      "lib.meta.getExe': The second argument is of type ${typeOf y}, but it should be a string instead.";
    assert assertMsg (match ".*/.*" y == null)
      "lib.meta.getExe': The second argument \"${y}\" is a nested path with a \"/\" character, but it should just be the name of the executable instead.";
    "${getBin x}/bin/${y}";

  /**
    Generate [CPE parts](#var-meta-identifiers-cpeParts) from inputs. Copies `vendor` and `version` to the output, and sets `update` to `*`.

    # Inputs

    `vendor`

    : package's vendor

    `version`

    : package's version

    # Type

    ```
    cpeFullVersionWithVendor :: string -> string -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.meta.cpeFullVersionWithVendor` usage example

    ```nix
    lib.meta.cpeFullVersionWithVendor "gnu" "1.2.3"
    => {
      vendor = "gnu";
      version = "1.2.3";
      update = "*";
    }
    ```

    :::
    :::{.example}
    ## `lib.meta.cpeFullVersionWithVendor` usage in derivations

    ```nix
    mkDerivation rec {
      version = "1.2.3";
      # ...
      meta = {
        # ...
        identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "gnu" version;
      };
    }
    ```
    :::
  */
  cpeFullVersionWithVendor = vendor: version: {
    inherit vendor version;
    update = "*";
  };

  /**
    Alternate version of [`lib.meta.cpePatchVersionInUpdateWithVendor`](#function-library-lib.meta.cpePatchVersionInUpdateWithVendor).
    If `cpePatchVersionInUpdateWithVendor` succeeds, returns an attribute set with `success` set to `true` and `value` set to the result.
    Otherwise, `success` is set to `false` and `error` is set to the string representation of the error.

    # Inputs

    `vendor`

    : package's vendor

    `version`

    : package's version

    # Type

    ```
    tryCPEPatchVersionInUpdateWithVendor :: string -> string -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.meta.tryCPEPatchVersionInUpdateWithVendor` usage example

    ```nix
    lib.meta.tryCPEPatchVersionInUpdateWithVendor "gnu" "1.2.3"
    => {
      success = true;
      value = {
        vendor = "gnu";
        version = "1.2";
        update = "3";
      };
    }
    ```

    :::
    :::{.example}
    ## `lib.meta.cpePatchVersionInUpdateWithVendor` error example

    ```nix
    lib.meta.tryCPEPatchVersionInUpdateWithVendor "gnu" "5.3p0"
    => {
      success = false;
      error = "version 5.3p0 doesn't match regex `([0-9]+\\.[0-9]+)\\.([0-9]+)`";
    }
    ```

    :::
  */
  tryCPEPatchVersionInUpdateWithVendor =
    vendor: version:
    let
      regex = "([0-9]+\\.[0-9]+)\\.([0-9]+)";
      # we have to call toString here in case version is an attrset with __toString attribute
      versionMatch = builtins.match regex (toString version);
    in
    if versionMatch == null then
      {
        success = false;
        error = "version ${version} doesn't match regex `${regex}`";
      }
    else
      {
        success = true;
        value = {
          inherit vendor;
          version = elemAt versionMatch 0;
          update = elemAt versionMatch 1;
        };
      };

  /**
    Generate [CPE parts](#var-meta-identifiers-cpeParts) from inputs. Copies `vendor` to the result. When `version` matches `X.Y.Z` where all parts are numerical, sets `version` and `update` fields to `X.Y` and `Z`. Throws an error if the version doesn't match the expected template.

    # Inputs

    `vendor`

    : package's vendor

    `version`

    : package's version

    # Type

    ```
    cpePatchVersionInUpdateWithVendor :: string -> string -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.meta.cpePatchVersionInUpdateWithVendor` usage example

    ```nix
    lib.meta.cpePatchVersionInUpdateWithVendor "gnu" "1.2.3"
    => {
      vendor = "gnu";
      version = "1.2";
      update = "3";
    }
    ```

    :::
    :::{.example}
    ## `lib.meta.cpePatchVersionInUpdateWithVendor` usage in derivations

    ```nix
    mkDerivation rec {
      version = "1.2.3";
      # ...
      meta = {
        # ...
        identifiers.cpeParts = lib.meta.cpePatchVersionInUpdateWithVendor "gnu" version;
      };
    }
    ```

    :::
  */
  cpePatchVersionInUpdateWithVendor =
    vendor: version:
    let
      result = tryCPEPatchVersionInUpdateWithVendor vendor version;
    in
    if result.success then result.value else throw result.error;
}
