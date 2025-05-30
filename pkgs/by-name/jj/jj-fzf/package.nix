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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    tag = "v${version}";
    hash = "sha256-StF0TKXTgtglFDbNTAU1c7Vw+6m70Mz2RvFon3difsk=";
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
