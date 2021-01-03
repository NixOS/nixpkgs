{ stdenv, fetchzip, fetchurl, installShellFiles, autoPatchelfHook, xar, cpio }:

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
        "i686-linux" = "107ziv8zh8ba6wi3m65cnky71pcyzaj7qb0dx5xldy57qsqk3smm";
        "x86_64-linux" = "0v3s0k0w526pzqa1r4n4zkfjkxfjw1blf7f0h57fwh915hcvc4lx";
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

  dontStrip = stdenv.isDarwin;

  postPhases = [ "postInstall" ];

  nativeBuildInputs = [ installShellFiles ] ++ stdenv.lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  installPhase = ''
    install -D op $out/bin/op
  '';

  # This needs to be done after patchelf has been ran on the binary
  postInstall = ''
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
    maintainers = with maintainers; [ joelburget marsam ];
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
