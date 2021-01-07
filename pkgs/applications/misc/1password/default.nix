{ stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "1.8.0";
  src =
    if stdenv.isLinux then fetchzip {
      url = {
        "i686-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        "x86_64-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
      }.${stdenv.hostPlatform.system};
      sha256 = {
        "i686-linux" = "teoxscan+EZ76Q0sfKT6nt1w/LSsmDoiN2oh+NGO/4A=";
        "x86_64-linux" = "nRK2GSwhQe5OgcAdR1fg0vUp3fzEkhwU/teIwsEEemw=";
      }.${stdenv.hostPlatform.system};
      stripRoot = false;
    } else fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.pkg";
      sha256 = "0pycia75vdfh6gxfd2hr32cxrryfxydid804n0v76l2fpr9v9v3d";
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
