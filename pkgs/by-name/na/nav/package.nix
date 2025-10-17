{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  libxcrypt-legacy,
}:

stdenv.mkDerivation rec {
  pname = "nav";
  version = "1.4.5";

  src = fetchurl {
    url = "https://github.com/Jojo4GH/nav/releases/download/v${version}/nav-${stdenv.hostPlatform.parsed.cpu.name}-unknown-linux-gnu.tar.gz";
    sha256 =
      {
        x86_64-linux = "sha256-N0C2rLKMNIgheNTjTStWOYliNuMKPPoxqtLAQSVV14Y=";
        aarch64-linux = "sha256-kl+CtXXmgF9gU5auFIDCV2BOZFWh05XfE8OtbDBnrs0=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  sourceRoot = ".";

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

  passthru.updateScript = ./update.sh;

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
