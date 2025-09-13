{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  electron,
}:

buildNpmPackage (finalAttrs: {
  pname = "solidtime-desktop";
  version = "0.0.39";

  src = fetchFromGitHub {
    owner = "solidtime-io";
    repo = "solidtime-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d3DPPVo3+NiZWCpk2NkHhlIpfl6JvMaGEdfh70XpkKA=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  npmDepsHash = "sha256-6Fmh4XIfVC+t3WOfKZy1QLRjzZV/Oe0q9LJ/2E34ATU=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/1024x1024
    cp -a build/icon.png $out/share/icons/hicolor/1024x1024/solidtime-desktop.png
    cp -a . $out/share/solidtime-desktop

    makeWrapper ${lib.getExe electron} $out/bin/solidtime-desktop \
      --add-flags $out/share/solidtime-desktop
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "solidtime-desktop";
      exec = "solidtime-desktop %U";
      icon = "solidtime-desktop";
      desktopName = "Solidtime Desktop";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/solidtime" ];
      terminal = false;
    })
  ];

  meta = {
    description = "Modern open-source time-tracking app";
    homepage = "https://github.com/solidtime-io/solidtime-desktop";
    changelog = "https://github.com/solidtime-io/solidtime-desktop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    mainProgram = "solidtime-desktop";
    maintainers = with lib.maintainers; [ hensoko ];
    platforms = lib.platforms.linux;
  };
})
