{
  callPackage,
  stdenv,
}:
if stdenv.isDarwin
then callPackage ./darwin.nix {}
else throw "chromium-bin has not been packaged for linux. use chromium instead"

