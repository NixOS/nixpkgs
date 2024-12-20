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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "synacktraa";
    repo = "ani-skip";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-VEEG3d6rwTAS7/+gBKHFKIg9zFfBu5eBOu6Z23621gM=";
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

    install -D skip.lua $out/share/mpv/scripts/skip.lua
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
    maintainers = [ lib.maintainers.diniamo ];
    platforms = lib.platforms.unix;
  };
})
