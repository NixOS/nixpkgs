{ stdenv, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "1password-${version}";
  version = "0.4";
  src =
    if stdenv.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "0mhlqvd3az50gnfil0xlq10855v3bg7yb05j6ndg4h2c551jrq41";
        stripRoot = false;
      }
    else if stdenv.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "15cv8xi4slid9jicdmc5xx2r9ag63wcx1mn7hcgzxbxbhyrvwhyf";
        stripRoot = false;
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v0.4/op_darwin_amd64_v${version}.zip";
        sha256 = "0yzr9m91k3lhl8am3dfzh4ql2zxsa66nw43h17ny61wraiz315cr";
        stripRoot = false;
      }
    else throw "Architecture not supported";

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -D op $out/bin/op
  '';
  postFixup = stdenv.lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/op
  '';

  meta = with stdenv.lib; {
    description = "1Password command-line tool";
    homepage    = [
      "https://blog.agilebits.com/2017/09/06/announcing-the-1password-command-line-tool-public-beta/"
      "https://app-updates.agilebits.com/product_history/CLI"
    ];
    maintainers = with maintainers; [ joelburget ];
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
