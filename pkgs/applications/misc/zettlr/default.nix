{ callPackage, texlive }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; inherit texlive; })) {
  zettlr = {
    version = "2.3.0";
    hash = "sha256-3p9RO6hpioYF6kdGV+/9guoqxaPCJG73OsrN69SHQHk=";
  };
  zettlr-beta = {
    version = "3.0.0-beta.7";
    hash = "sha256-zIZaINE27bcjbs8yCGQ3UKAwStFdvhHD3Q1F93LrG4U=";
  };
}
