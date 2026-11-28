{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4215";
    x64sha256 = "wVP0GNOrJrkOzOjAKoLk6WECXtemX34lBgpUV9Q+iNk=";
    aarch64sha256 = "0xRmWkJy8zVRUDQyNyo0UW27WpoS3OKkcELBlC9m7nk=";
  } { };

  sublime4-dev = common {
    buildVersion = "4214";
    dev = true;
    x64sha256 = "KrAMdjZreCzr00sO+QXoI11TB4wmHGQz9meMiIY9uR8=";
    aarch64sha256 = "OQ6EL24mVETY4PdcZi1UKbWgNTreMq9TrP9fFN1qDfk=";
  } { };
}
