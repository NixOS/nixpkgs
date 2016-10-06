# nixpkgs/nixos release information
rec {

  # formatting releases
  asString = {
    name
  , releaseDate
  }: "${name} (release date ${releaseDate})";

  next = nixos-17-first;

  nixos-17-first = {
    name = "NixOS 17.?";
    releaseDate = "early 2017";
  };

  "nixos-16.09" = {
    name = "NixOS 16.09";
    releaseDate = "2016-10-03";
  };

}
