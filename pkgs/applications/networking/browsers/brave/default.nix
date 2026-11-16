{ callPackage }:

let
  flavorData = {
    browser = {
      optStem = "brave";
      fileStem = "brave-browser";
      appIdStem = "com.brave.Browser";
      darwinStem = "Brave Browser";
      changelogFile = "CHANGELOG_DESKTOP.md";
      homepage = "https://brave.com/";
      innerBinary = "brave";
    };
    origin = {
      optStem = "brave-origin";
      fileStem = "brave-origin";
      appIdStem = "com.brave.Origin";
      darwinStem = "Brave Origin";
      changelogFile = "CHANGELOG_DESKTOP_ORIGIN.md";
      homepage = "https://brave.com/origin/";
      innerBinary = "brave";
    };
  };

  mkBrave =
    release:
    let
      pkg = import release;
      fd = flavorData.${pkg.flavor or "browser"};
    in
    callPackage ((import ./make-brave.nix) (pkg // fd)) { };

in
{
  brave = mkBrave ./packages/brave.nix;
  brave-origin = mkBrave ./packages/brave-origin.nix;
}
