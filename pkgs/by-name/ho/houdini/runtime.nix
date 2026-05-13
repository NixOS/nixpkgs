{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "21.0.559";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-bZmoH1NKQhhMAhIl3pTL7irUZ7HrOhS8R7GApLD5514=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-/7ctlMUoyJdPdBQV7rRO9pWcg9bXcnMJsB9TN/Jo8QQ=";
}
