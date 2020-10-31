{ stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "1.7.0";
  src =
    if stdenv.isLinux then fetchzip {
      url = {
        "i686-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        "x86_64-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
      }.${stdenv.hostPlatform.system};
      sha256 = {
        "i686-linux" = "0fvi9pfcm6pfy628q2lg62bkikrgsisynrk3kkjisb9ldcyjgabw";
        "x86_64-linux" = "1iskhls8g8w2zhk79gprz4vzrmm7r7fq87gwgd4xmj5md4nkzran";
      }.${stdenv.hostPlatform.system};
      stripRoot = false;
    } else fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_darwin_amd64_v${version}.pkg";
      sha256 = "0x6s26zgjryzmcg9qxmv5s2vml06q96yqbapasjfxqc3l205lnnn";
    };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ xar cpio ];

  postPhases = [ "postInstall" ];

  unpackPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat Payload | cpio -i
  '';

  installPhase = ''
    install -D op $out/bin/op
  '';

  postInstall = ''
    installShellCompletion --bash --name op <($out/bin/op completion bash)
    installShellCompletion --zsh --name _op <($out/bin/op completion zsh)
  '';

  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = [ installShellFiles ] ++ stdenv.lib.optionals stdenv.isLinux [ autoPatchelfHook ];

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
