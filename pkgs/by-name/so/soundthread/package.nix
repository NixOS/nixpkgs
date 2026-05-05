{
  lib,
  stdenv,
  fetchFromGitHub,
  godot,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundthread";
  version = "0.4.0-beta";

  src = fetchFromGitHub {
    owner = "j-p-higgins";
    repo = "SoundThread";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JOmi+qJpoE+lZFlaedvQFHaMvlbSQWRQAVFQO/Bi+Ys=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    godot
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
    ln -s "${godot.export-template}"/share/godot/export_templates "$HOME"/.local/share/godot/
    mkdir -p build
    godot4 --headless --export-release "Linux" ./build/soundthread

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/soundthread
    install -D -m 644 -T ./theme/images/icon.png $out/share/icons/hicolor/256x256/apps/soundthread.png
    install -d -m 755 $out/bin
    ln -s $out/libexec/soundthread $out/bin/soundthread

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/j-p-higgins/SoundThread";
    description = "Node based GUI for The Composers Desktop Project";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jpotier ];
    mainProgram = "soundthread";
  };
})
