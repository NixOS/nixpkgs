{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "0.5.6-003";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "11smnx8fh32qm3b82x2ps4y46q29h77x1j1dj3d5vs0vha9b8frj";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "1qwxga6qmb3n76h2fl1lxhnz676cqbx8gic1b5c9hw88gnqwykb9";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.zip";
        sha256 = "0gzmwc20liqx2cqply06yarwp228ydfgfb26bmpxbvlp0cq7d07g";
        stripRoot = false;
      }
    else throw "Architecture not supported";

  installPhase = ''
    install -D op $out/bin/op
  '';
  postFixup = stdenv.lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/op
  '';

  meta = with stdenv.lib; {
    description  = "1Password command-line tool";
    homepage     = https://support.1password.com/command-line/;
    downloadPage = https://app-updates.agilebits.com/product_history/CLI;
    maintainers  = with maintainers; [ joelburget ];
    license      = licenses.unfree;
    platforms    = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
