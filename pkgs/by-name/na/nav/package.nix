{
  stdenv,
  lib,
  fetchzip,
  writeScript,
  nix-update,
  autoPatchelfHook,
  libxcrypt-legacy,
}:

stdenv.mkDerivation rec {
  pname = "nav";
  version = "1.3.1";

  src = fetchzip {
    url = "https://github.com/Jojo4GH/nav/releases/download/v${version}/nav-${stdenv.hostPlatform.parsed.cpu.name}-unknown-linux-gnu.tar.gz";
    sha256 =
      {
        x86_64-linux = "sha256-ZDta1qbkdR3p9BJ0fy7or8MvE6QCL+wCKWd/KLavrhw=";
        aarch64-linux = "sha256-RD6z/oNjCwig7NC+9qK5eKAoqtQIbL11tmY5jkqeoc8=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc.lib
    libxcrypt-legacy
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp nav $out/bin

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update" ''
    ${nix-update}/bin/nix-update nav --system x86_64-linux
    ${nix-update}/bin/nix-update nav --system aarch64-linux --version "skip"
  '';

  meta = {
    description = "Interactive and stylish replacement for ls & cd";
    longDescription = ''
      To make use of nav, add the following lines to your configuration:
      `programs.bash.shellInit = "eval \"$(nav --init bash)\"";` and
      `programs.zsh.shellInit = "eval \"$(nav --init zsh)\"";`
    '';
    homepage = "https://github.com/Jojo4GH/nav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      David-Kopczynski
      Jojo4GH
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "nav";
  };
}
