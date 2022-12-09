{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2079";
    x64sha256 = "y4ocLXxxEkGaw9O/vhX9MJnc56QgK37YPJkUwK2YS0U=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2078";
    x64sha256 = "33oJOnsOUr9W+OGMetafaGtXUa+CHxxLjmtDoZliw0k=";
    dev = true;
  } {};
}
