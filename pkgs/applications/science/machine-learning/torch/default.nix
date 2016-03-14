{pkgs, fetchgit} :
let
  src = fetchgit {
    url = "https://github.com/grwlf/torch-distro";
    rev = "fa3a02066e5aeb08dae3bde970384e0a96887710";
    sha256 = "0rin42dmgyl935rvin7dq6bnav2gj84xz1idzyf9by4p3zb7w3cr";
  };

in
  import ./torch-distro.nix { inherit pkgs src; }
