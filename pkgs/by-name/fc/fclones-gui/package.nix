{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libadwaita,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fclones-gui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = "fclones-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ad7wyoCjSQ8i6c+4IorImqAY2Q6pwBtI2JkkbkGa46U=";
  };

  cargoHash = "sha256-01HNWhHfbun+Er39eN5tEmqXMGDsBQrZtVTA9R7kifo=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libadwaita
  ];

  postInstall = ''
    substituteInPlace snap/gui/fclones-gui.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/fclones-gui.png' "Icon=fclones-gui"
    install -Dm 0644 snap/gui/fclones-gui.desktop -t $out/share/applications
    install -Dm 0644 snap/gui/fclones-gui.png -t $out/share/icons/hicolor/256x256/apps
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Interactive duplicate file remover";
    mainProgram = "fclones-gui";
    homepage = "https://github.com/pkolaczk/fclones-gui";
    changelog = "https://github.com/pkolaczk/fclones-gui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = [ lib.maintainers.progrm_jarvis ];
=======
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
