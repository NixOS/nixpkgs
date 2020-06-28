{ stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "1.1.1";
  src =
    if stdenv.isLinux then fetchzip {
      url = {
        "i686-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        "x86_64-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
      }.${stdenv.hostPlatform.system};
      sha256 = {
        "i686-linux" = "1andl3ripkcg4jhwdkd4b39c9aaxqpx9wzq21pysn6rlyy4hfcb0";
        "x86_64-linux" = "0qj5v8psqyp0sra0pvzkwjpm28kx3bgg36y37wklb6zl2ngpxm5g";
      }.${stdenv.hostPlatform.system};
      stripRoot = false;
    } else fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.pkg";
      sha256 = "16inwxkrky4xwlr7vara1l8kapdgjg3kfq1l94i5855782hn4ppm";
    };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ xar cpio ];

  unpackPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat Payload | cpio -i
  '';

  installPhase = ''
    install -D op $out/bin/op
  '';

  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/op --version
  '';

  meta = with stdenv.lib; {
    description  = "1Password command-line tool";
    homepage     = "https://support.1password.com/command-line/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI";
    maintainers  = with maintainers; [ joelburget marsam ];
    license      = licenses.unfree;
    platforms    = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
