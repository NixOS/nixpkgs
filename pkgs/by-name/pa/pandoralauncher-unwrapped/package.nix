{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  openssl,
  dbus,
  libxcb,
  jdk8,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pandoralauncher-unwrapped";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "Moulberry";
    repo = "PandoraLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pdeKtN/Zv97LGX4bscR8DwNzHx/Yk15ckDM7MP7oDgg=";
  };

  cargoHash = "sha256-e2QZnwv8Wl4rr+4wCTWhJu9Xq8ZFgJ4iArLc7nRLUuM=";

  nativeBuildInputs = [
    pkg-config
    jdk8
  ];

  buildInputs = [
    openssl
    libxkbcommon
    dbus
    libxcb
  ];

  preBuild = ''
    (
      cd wrapper
      rm com/moulberry/pandora/LaunchWrapper.class
      javac com/moulberry/pandora/LaunchWrapper.java
      jar cvfm LaunchWrapper.jar manifest.txt com/moulberry/pandora/LaunchWrapper.class
    )
  '';

  postInstall = ''
    install -Dm444 package/flatpak/com.moulberry.PandoraLauncher.desktop $out/share/applications/PandoraLauncher.desktop

    substituteInPlace $out/share/applications/PandoraLauncher.desktop \
    --replace-fail "Icon=com.moulberry.PandoraLauncher" "Icon=PandoraLauncher"

    for size in 16 32 48 256; do
      install -Dm444 package/windows_icons/icon_"$size"x"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/PandoraLauncher.png
    done
  '';

  meta = {
    description = "Modern Minecraft launcher that balances ease-of-use with powerful instance management features";
    homepage = "https://pandora.moulberry.com/";
    changelog = "https://github.com/Moulberry/PandoraLauncher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pandora_launcher";
    maintainers = [ lib.maintainers.ind-e ];
    platforms = lib.platforms.linux;
  };
})
