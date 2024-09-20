{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.332";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-ZqbLCWfPUo0fXS9liKOXsUEpm1d60bHIkbx+K98gFtU=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
