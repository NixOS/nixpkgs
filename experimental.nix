let
  nixpkgs = import ./. {};
  inherit (nixpkgs) cmus;
  inherit (nixpkgs.lib) rfc0169Renamed;
in {
  cmus2 = (rfc0169Renamed cmus.override) { with_alsa = false; };
  cmus3 = (rfc0169Renamed cmus.override) { alsaSupport = false; };
}
