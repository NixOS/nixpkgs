{
  lib,
  makeDesktopItem,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  stdenv,
  makeWrapper,
  libGL,
  libxkbcommon,
  wayland,
  vulkan-loader,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  xdg-utils,
  copyDesktopItems,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gophie";
  version = "2.3.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jankammerath";
    repo = "gophie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5L57lYWPIbY/Kwk//JBqZunMvU2ZsTopQhDB7Fytx0=";
  };

  cargoHash = "sha256-bGHXGjFWiGOYV/9VyTEv4bYgukW7VRIuKEZTTR6+PqY=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "gophie";
      exec = "gophie %u";
      icon = "gophie";
      comment = finalAttrs.meta.description;
      desktopName = "Gophie";
      categories = [
        "Network"
        "WebBrowser"
      ];
      terminal = false;
      genericName = "Gopher Browser";
      mimeTypes = [ "x-scheme-handler/gopher" ];
    })
  ];

  postInstall = ''
    install -Dm444 res/icon.png $out/share/icons/hicolor/256x256/apps/gophie.png
    wrapProgram $out/bin/gophie \
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        wayland
        vulkan-loader
        libx11
        libxcb
        libxcursor
        libxi
        libxrandr
      ]
    } \
  ''
  + ''
    --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform client for the Gopher protocol";
    homepage = "https://github.com/jankammerath/gophie";
    changelog = "https://github.com/jankammerath/gophie/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "gophie";
  };
})
