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
    hash = "sha256-PhdspIr0Lnuv4e8bjMEAXnVDK1YVlrI5XI+rP9qXNQ0=";
  };

  postPatch = ''
    patchShebangs buildfile
    substituteInPlace buildfile \
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
    git
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
