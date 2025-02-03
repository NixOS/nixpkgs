{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kara";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "dhruv8sh";
    repo = "kara";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-G+sLHcHnNuzIRE+6bvEeXaWYVdoqqxcp5kGF8ZhD/34=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids/org.dhruv8sh.kara
    cp metadata.json $out/share/plasma/plasmoids/org.dhruv8sh.kara
    cp -r contents $out/share/plasma/plasmoids/org.dhruv8sh.kara

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma Applet for use as a desktop/workspace pager";
    homepage = "https://github.com/dhruv8sh/kara";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
