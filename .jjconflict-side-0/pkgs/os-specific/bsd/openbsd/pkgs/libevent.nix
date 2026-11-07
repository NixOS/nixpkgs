{ mkDerivation }:
mkDerivation {
  path = "lib/libevent";
  preInstall = ''
    mkdir -p $out/include
  '';
}
