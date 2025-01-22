{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.445";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-rk8HKX1Aq7ACbAWKFxfjSzfa3PA/iXQZsYOkr/kSbkM=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-bdL+Ha5LWkty4r+rgPAKr50pxV+j7CLspD4KOsSxyMo=";
}
