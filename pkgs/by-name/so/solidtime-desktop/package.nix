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

buildNpmPackage rec {
  pname = "solidtime-desktop";
  version = "0.0.39";

  src = fetchFromGitHub {
    owner = "solidtime-io";
    repo = "solidtime-desktop";
    rev = "v${version}";
    hash = "sha256-d3DPPVo3+NiZWCpk2NkHhlIpfl6JvMaGEdfh70XpkKA=";
  };

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ];

  npmDepsHash = "sha256-6Fmh4XIfVC+t3WOfKZy1QLRjzZV/Oe0q9LJ/2E34ATU=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postInstall = ''
    mkdir -p $out/opt
    cp -a . $out/opt/solidtime-desktop

    makeWrapper ${lib.getExe electron} $out/bin/solidtime-desktop \
      --add-flags $out/opt/solidtime-desktop
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "solidtime-desktop";
      exec = "solidtime-desktop %U";
      icon = "solidtime-desktop";
      desktopName = "Solidtime Desktop";
      comment = meta.description;
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/solidtime" ];
      terminal = false;
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/solidtime-io/solidtime-desktop/releases/tag/${src.rev}";
    description = "Solidtime Desktop application powered by Electron";
    homepage = "https://github.com/solidtime-io/solidtime-desktop";
    license = licenses.agpl3Only;
    mainProgram = "solidtime-desktop";
    maintainers = [ maintainers.hensoko ];
    platforms = platforms.linux;
  };
}
