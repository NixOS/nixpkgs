{ stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "0.9.4";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "0hgvcm42035fs2qhhvycppcrqgya98rmkk347j3hyj1m6kqxi99c";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "1fvl078kgpvzjr3jfp8zbajzsiwrcm33b7lqksxgcy30paqw6737";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.pkg";
        sha256 = "0fzbfxsgf0s93kg647zla9n9k5adnfb57dcwwnibs6lq5k63h8mj";
      }
    else throw "Architecture not supported";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ xar cpio ];

  unpackPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat Payload | cpio -i
  '';

  installPhase = ''
    install -D op $out/bin/op
  '';

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  meta = with stdenv.lib; {
    description  = "1Password command-line tool";
    homepage     = "https://support.1password.com/command-line/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI";
    maintainers  = with maintainers; [ joelburget marsam ];
    license      = licenses.unfree;
    platforms    = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
