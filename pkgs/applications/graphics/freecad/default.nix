import ./generic.nix rec {
  pname = "freecad";
  version = "0.21.2";
  owner = "FreeCAD";
  rev = version;
  hash = "sha256-OX4s9rbGsAhH7tLJkUJYyq2A2vCdkq/73iqYo9adogs=";
  patches = [ ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch ];
}
