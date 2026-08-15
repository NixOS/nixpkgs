{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "22.0.368";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc14.2.tar.gz";
    hash = "sha256-h2UzXwkKgyl2i0FbZLyfuAoNmWOxP2NFWtBC4y01NhY=";
    url = "https://www.sidefx.com/download/daily-builds/?show_launcher=false&production=true&linux=true";
  };
  outputHash = "sha256-sJwKbkmHykgyP6yio5W8FVxLWm2S0PEQz5RVRF3cbfI=";
}
