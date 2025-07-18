{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.550";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-3WqZkSw7dhwqcHe8kPOJylvs1W1u5D0X21Vo943366E=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-DG1raIDPxFv/IQM8qmHFu8hJEba9t2UyCL7O8jpKjGY=";
}
