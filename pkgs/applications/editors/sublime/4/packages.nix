{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4189";
    x64sha256 = "0vEG2FfLK+93UtpYV9iWl187iN79Tozm38Vh6lbzW7A=";
    aarch64sha256 = "ZyLnbvpyxvJfyfu663ED0Yn5M37As+jy6TREZMgSHgI=";
  } { };

  sublime4-dev = common {
    buildVersion = "4188";
    dev = true;
    x64sha256 = "b7JyJ9cPxb/Yjy9fvcz/m6OLETxMd8rwkmrEyMGAjjc=";
    aarch64sha256 = "oGL0UtQge21oH6p6BNsRkxqgvdi9PkT/uwZTYygu+ng=";
  } { };
}
