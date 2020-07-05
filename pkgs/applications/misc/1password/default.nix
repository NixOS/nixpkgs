{ stdenv, fetchzip, fetchurl, autoPatchelfHook, xar, cpio, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "1.2.0";
  src =
    if stdenv.isLinux then fetchzip {
      url = {
        "i686-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        "x86_64-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
      }.${stdenv.hostPlatform.system};
      sha256 = {
        "i686-linux" = "1fpmglqj7qqaa7k79ngrf16qq6rv4m8b57hzq87fyj22myaxydjy";
        "x86_64-linux" = "0c0zj3bv0rgdqaanm6gk7fsy5ckj5h8zc5jckrv1nsfqr7lpbydd";
      }.${stdenv.hostPlatform.system};
      stripRoot = false;
    } else fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.pkg";
      sha256 = "0sc5fi55gcbjmj5cp9clilkdz7c6nzqyyh1fficfafh8il4qvki6";
    };

  nativeBuildInputs = [ installShellFiles ]
    ++ stdenv.lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ xar cpio ];

  unpackPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat Payload | cpio -i
  '';

  dontStrip = stdenv.isDarwin;

  installPhase = ''
    install -D op $out/bin/op
    $out/bin/op completion bash > op.bash
    $out/bin/op completion zsh > op.zsh
    installShellCompletion op.{bash,zsh}
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/op --version
  '';

  meta = with stdenv.lib; {
    description = "1Password command-line tool";
    homepage = "https://support.1password.com/command-line/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI";
    maintainers = with maintainers; [ joelburget marsam ivar ];
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
