{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "1password-${version}";
  version = "0.5.4";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "0wni2hk5b1qfr24vi24jiprpi08k3qgaw9lqp61k41a1sjp3izv0";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "169d5fl3cfw3xrlpm9nlmwbnp0xgh0la9qybzf8ragp0020nlyih";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.zip";
        sha256 = "1scikv7v33kzg9rqsrz97yklxaskvif84br13zg8annm43k5vlma";
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
