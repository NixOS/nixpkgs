{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  makeWrapper,
  jre,
  lib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "bloop";
  version = "2.1.1";

  platform =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
      "x86_64-pc-linux"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then
      "x86_64-apple-darwin"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      "aarch64-apple-darwin"
    else
      throw "unsupported platform";

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = "sha256-2mt+zUEJvQ/5ixxFLZ3Z0m7uDSj/YE9sg/uNMjamvdE=";
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = "sha256-eFESR6iPHRDViGv+Fk3sCvPgVAhk2L1gCG4LnfXO/v4=";
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = "sha256-WNMsPwBfd5EjeRbRtc06lCEVI2FVoLfrqL82OR0G7/c=";
  };

  bloop-binary = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bloop-${platform}";
    sha256 =
      if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
        "sha256-F5wRihAwf/TNBSYortTCoK9qKqTI+1N5InJ+rqLFp8A="
      else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then
        "sha256-wQXAldzU6Typ6pZB8k3dfX7g+aaVF7jXvd0pnuk5gZU="
      else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        "sha256-OrONKbC2l0jjfmguDmoiyEaJWdTrKBiP0ZEa5rhizDM="
      else
        throw "unsupported platform";
  };

  dontUnpack = true;
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    zlib
  ];
  propagatedBuildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 ${bloop-binary} $out/.bloop-wrapped

    makeWrapper $out/.bloop-wrapped $out/bin/bloop

    #Install completions
    installShellCompletion --name bloop --bash ${bloop-bash}
    installShellCompletion --name _bloop --zsh ${bloop-zsh}
    installShellCompletion --name bloop.fish --fish ${bloop-fish}

    runHook postInstall
  '';

  meta = {
    homepage = "https://scalacenter.github.io/bloop/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    description = "Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way";
    mainProgram = "bloop";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      agilesteel
      kubukoz
      tomahna
    ];
  };
}
