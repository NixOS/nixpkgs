{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "1password-${version}";
  version = "0.5.1";
  src =
    if stdenv.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "08kzjilxpkvlwqjyxnic1n6xiy6gkndijwxdksm59k7c56mdawsz";
        stripRoot = false;
      }
    else if stdenv.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "1bsbzaqws0z991r6rkjrxay74fj4g5ld4d748ygr0950zwi1m3h7";
        stripRoot = false;
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.zip";
        sha256 = "1dhr8m9icip27v802gxl1vhl9rf0jq5awirdm72lqmlypj86df0g";
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
