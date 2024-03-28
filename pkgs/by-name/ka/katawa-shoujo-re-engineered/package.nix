{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  renpy,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "katawa-shoujo-re-engineered";
  version = "1.4.4";

  src = fetchFromGitHub {
    /*
      # alternative source:
      fetchFromGitea {
        domain = "codeberg.org";
        owner = "fhs";
        repo = "katawa-shoujo-re-engineered";
    */
    owner = "fleetingheart";
    repo = "ksre";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RYJM/wGVWqIRZzHLUtUZ5mKUrUftDVaOwS1f/EpW6Tk=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    echo "#!/${stdenvNoCC.shell}
    ${lib.getExe' renpy "renpy"} $src run" > $out/bin/${finalAttrs.meta.mainProgram}
    chmod +x $out/bin/${finalAttrs.meta.mainProgram}
    runHook postInstall
  '';

  meta = {
    description = "A fan-made modernization of the classic visual novel Katawa Shoujo";
    homepage = "https://www.fhs.sh/projects"; # or https://codeberg.org/fhs/katawa-shoujo-re-engineered
    mainProgram = "katawa-shoujo-re-engineered";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    license = with lib.licenses; [
      # code
      mpl20
      # assets from the original game
      cc-by-nc-nd-30
    ];
  };
})
