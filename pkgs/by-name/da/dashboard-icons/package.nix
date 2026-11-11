{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

# Pure asset package: upstream publishes no releases/tags, main is the
# source of truth and is updated frequently, so this tracks a pinned commit
# with an unstable date version.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dashboard-icons";
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "dashboard-icons";
    rev = "d767d7327db7f8ebd3715b552523f61889eea41c";
    hash = "sha256-cfhHffmJ0P/AaHYpLgkzj5NfhrbI4xEeYKhLMAMvL/c=";
  };

  installPhase = ''
    runHook preInstall

    # png/svg/webp icon sets + metadata.json (tag/color index used by
    # consumers); LICENSE is shipped alongside the assets it covers, since
    # the icon directories are typically served verbatim by dashboards.
    mkdir -p $out/share/dashboard-icons
    cp -r png svg webp metadata.json $out/share/dashboard-icons/
    install -Dm644 LICENSE $out/share/dashboard-icons/LICENSE

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Source of uniquely designed icons for self-hosted dashboards";
    longDescription = ''
      Community-maintained icon library (3,400+ curated icons) used across
      the self-hosted dashboard ecosystem: Homarr, Homepage, Dashy and
      others. Icons are provided in png, svg and webp, plus metadata.json
      with tags and brand colors for search UIs.
    '';
    homepage = "https://github.com/homarr-labs/dashboard-icons";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ luochen1990 ];
    platforms = lib.platforms.all;
  };
})
