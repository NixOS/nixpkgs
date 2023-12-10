import ./generic.nix rec {
  pname = "freecad-realthunder";
  version = "2023.01.31";
  owner = "realthunder";
  rev = "${version}-edge";
  hash = "sha256-gUziaW0HdhbNvl6rZz7n18e5f7RTHUyV8FRTkd2uzdE=";
  patches = [ ./0001-NIXOS-realthunder-don-t-ignore-PYTHONPATH.patch ];
}
