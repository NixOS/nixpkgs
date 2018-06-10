{ stdenv, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "1password-${version}";
  version = "0.4.1";
  src =
    if stdenv.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v0.4.1/op_linux_386_v${version}.zip";
        sha256 = "0mv2m6rm6bdpca8vhyx213bg4kh06jl2sx8q7mnrp22c3f0yzh7f";
        stripRoot = false;
      }
    else if stdenv.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v0.4.1/op_linux_amd64_v${version}.zip";
        sha256 = "016h5jcy6jic8j3mvlnpcig9jxs22vj71gh6rrap2q950bzi6fi1";
        stripRoot = false;
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v0.4.1/op_darwin_amd64_v${version}.zip";
        sha256 = "1l0bi0f6gd4q19wn3v409gj64wp51mr0xpb09da1fl33rl5fpszb";
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
