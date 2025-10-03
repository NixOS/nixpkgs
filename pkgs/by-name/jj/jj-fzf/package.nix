{
  lib,
  bashInteractive,
  coreutils,
  fetchFromGitHub,
  fzf,
  gawk,
  gnused,
  jujutsu,
  makeWrapper,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "jj-fzf";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    tag = "v${version}";
    hash = "sha256-aJyKVMg/yI2CmAx5TxN0w670Rq26ESdLzESgh8Jr4nE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D jj-fzf $out/bin/jj-fzf
    substituteInPlace $out/bin/jj-fzf \
      --replace-fail "/usr/bin/env bash" "${lib.getExe bashInteractive}"
    wrapProgram $out/bin/jj-fzf \
      --prefix PATH : ${
        lib.makeBinPath [
          bashInteractive
          coreutils
          fzf
          gawk
          gnused
          jujutsu
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
