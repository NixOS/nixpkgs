{
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  gnugrep,
  gnused,
  curl,
  fzf,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ani-skip";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "synacktraa";
    repo = "ani-skip";
    tag = finalAttrs.version;
    hash = "sha256-8EXJIY/YqTe2H0JDX/feMISCnHl2zs1LnvBkEk7Sss0=";
  };

  nativeBuildInputs = [ makeWrapper ];
  runtimeInputs = [
    gnugrep
    gnused
    curl
    fzf
  ];

  installPhase = ''
    runHook preInstall

    install -D integrations/mpv.lua $out/share/mpv/scripts/skip.lua
    install -Dm 755 ani-skip $out/bin/ani-skip

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/bin/ani-skip \
      --replace-fail '--script-opts=%s' "--script=$out/share/mpv/scripts/skip.lua --script-opts=%s"

    wrapProgram $out/bin/ani-skip \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs}
  '';

  meta = {
    homepage = "https://github.com/synacktraa/ani-skip";
    description = "Automated solution to bypassing anime opening and ending sequences";
    mainProgram = "ani-skip";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
