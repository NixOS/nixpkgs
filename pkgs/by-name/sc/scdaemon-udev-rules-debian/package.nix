{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scdaemon-udev-rules-debian";
  version = "2.4.9-4";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "gnupg2";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-3xeEoQLBTmwgJQkYYAM6Ctx9TAq+YTTXlANUl/zOM0k=";
  };

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/udev/rules.d
    cp debian/scdaemon.udev $out/lib/udev/rules.d/60-scdaemon.rules

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "udev rules for scdaemon as packaged by Debian";
    homepage = "https://salsa.debian.org/debian/gnupg2";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})
