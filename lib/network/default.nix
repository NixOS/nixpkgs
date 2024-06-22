/*
  <!-- This anchor is here for backwards compatibity -->
  []{#sec-network}

  The `lib.network` library allows you to work with IPv4 addresses in CIDR notation.

  ## IPv4 {#sec-network-ipv4}

  ### Structure {#sec-network-ipv4-structure}

  The `lib.network.ipv4` library provides ingestion functions the create an `IPv4Address` object.
  This is an attribute set with these values:

  - `cidr`: A CIDR.
  - `address`: An IP address.
  - `prefixLength`: A prefix length.
  - `subnetMask`: A subnet mask.

  - [`lib.network.ipv4.fromCidrString`](#function-library-lib.network.ipv4.fromCidrString):

  Creates an `IPv4Address` object from an IPv4 address in CIDR notation as a string.
*/

{ lib }:
let
  internal = import ./internal.nix { inherit lib; };
in
{
  /**
    Creates an `IPv4Address` object from an IPv4 address in CIDR notation as a string.

    # Example

    ```nix
    fromCidrString "192.168.0.1/24"
    => {
      address = "192.168.0.1";
      cidr = "192.168.0.1/24";
      prefixLength = "24";
    }
    ```

    # Type

    ```
    fromCidrString :: String -> IPv4Address
    ```

    # Arguments

    - [cidr] An IPv4 address in CIDR notation.
  */
  ipv4.fromCidrString =
    cidr:
    let
      address = internal.ipv4._verifyAddress cidr;
      prefixLength = internal.ipv4._verifyPrefixLength cidr;
    in
    internal.ipv4._parse address prefixLength;
}
