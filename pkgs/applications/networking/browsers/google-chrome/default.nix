{
  callPackage
, lib
, stdenv

# Which distribution channel to use.
, channel ? "stable"

# Only needed for getting information about upstream binaries
, chromium
}:

let
  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;
in callPackage package {
  inherit channel;

  meta = with lib; {
    description = "A freeware web browser developed by Google";
    homepage = "https://www.google.com/chrome/browser/";
    license = licenses.unfree;
  };
}
