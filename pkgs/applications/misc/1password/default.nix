{ stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "0.10.0";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        sha256 = "07j11ikd0rzsj4d8rv74rfy497svq6l2q94ndf3b0a0mr8riyazj";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        sha256 = "177cl4x7rj3d74kzrpmiwps5n31axmlhqdwrdpkmay2gk9inswbs";
        stripRoot = false;
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.pkg";
        sha256 = "13yxmnh77g6zvl2gqf77m5i3v5706p2plgbgsn5hqrrf3g8ql63b";
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
