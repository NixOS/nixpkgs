{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
}:
stdenvNoCC.mkDerivation {
  pname = "gruvbox-gtk-theme";
  version = "0-unstable-2024-06-12";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "1a0f6672283e1846ec307addd4647f2daad29402";
    hash = "sha256-bbL4bHAdkmReogUQML9sMpSallZ7wrgbK3R64xiAYRo=";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  buildInputs = [ gnome-themes-extra ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = {
    description = "Gtk theme based on the Gruvbox colour pallete";
    homepage = "https://www.pling.com/p/1681313/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      math-42
    ];
  };
}
