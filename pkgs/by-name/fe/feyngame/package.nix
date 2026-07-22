{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  jdk,
  jre,
  desktop-file-utils,
  git,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "feyngame";
  version = "3.0.0";

  src = fetchFromGitLab {
    owner = "feyngame";
    repo = "FeynGame";
    tag = finalAttrs.version;
    leaveDotGit = true; # the build script uses git log to find last commit date
    hash = "sha256-ySBEka978jRWRRI6WpKNEfwsB3kZMhOrcotbstTAhzQ=";
    postFetch = ''
      git --git-dir=$out/.git log -1 --date=format:"%d.%m.%Y %H:%M:%S" --format="%ad" > $out/.gitdate
      rm -rf $out/.git
    '';
  };

  postPatch = ''
    patchShebangs buildfile
    substituteInPlace buildfile \
      --replace-fail 'git log -1 --date=format:"%d.%m.%Y %H:%M:%S" --format="%ad"' 'cat .gitdate' \
      --replace-fail '$Prefix/bin/feyngame %U' 'feyngame %U' \
      --replace-fail '$Prefix/share/pixmaps/fglogo.png' 'fglogo'
  '';

  # The build script includes both building and installing steps.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    OSTYPE=${if stdenvNoCC.hostPlatform.isDarwin then "darwin" else "linux-gnu"} ./buildfile -i "$out"

    runHook postInstall
  '';

  nativeBuildInputs = [
    jdk
    desktop-file-utils
  ];
  buildInputs = [ jre ];
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java-based graphical tool for drawing Feynman diagrams";
    homepage = "https://gitlab.com/feyngame/FeynGame";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = jre.meta.platforms;
    mainProgram = "feyngame";
  };
})
