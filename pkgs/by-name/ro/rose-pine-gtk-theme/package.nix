{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rose-pine-gtk-theme";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vCWs+TOVURl18EdbJr5QAHfB+JX9lYJ3TPO6IklKeFE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # avoid the makefile which is only for theme maintainers
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # gtk-2.0 is skipped: it needs gtk-engine-murrine, which is no longer packaged.
    shopt -s extglob

    variants=("rose-pine" "rose-pine-dawn" "rose-pine-moon")
    for n in "''${variants[@]}"; do
      install -d "$out/share/themes/$n/gtk-4.0"
      cp -r $src/gtk3/"$n"-gtk/!(gtk-2.0) "$out/share/themes/$n"
      cp -r $src/gtk4/"$n".css "$out/share/themes/$n/gtk-4.0/gtk.css"
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rosé Pine theme for GTK";
    homepage = "https://github.com/rose-pine/gtk";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
