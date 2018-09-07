{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "1password-${version}";
  version = "0.5.3";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "05s223h1yps4k9kmignl0r5sbh6w7m1hnlmafnf1kiwv7gacvxjc";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "0p9x1fx0309v8dxxaf88m8x8q15zzqywfmjn6v5wb9v3scp9396v";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.zip";
        sha256 = "1z2xp9bn93gr4ha6zx65va1fb58a2xlnnmpv583y96gq3vbnqdcj";
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
