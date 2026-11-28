{
  lib,
  stdenv,
  fetchFromGitHub,
  libnetfilter_conntrack,
  ncurses,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iptstate";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "jaymzh";
    repo = "iptstate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lur2YM4w/K5lgCpIBmV69r8iv/1XJ8eEJB3Fpw7j0B8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libnetfilter_conntrack
    ncurses
  ];

  installPhase = ''
    install -m755 -D iptstate $out/bin/iptstate
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Conntrack top like tool";
    mainProgram = "iptstate";
    homepage = "https://github.com/jaymzh/iptstate";
    changelog = "https://github.com/jaymzh/iptstate/blob/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kamadorueda ];
    downloadPage = "https://github.com/jaymzh/iptstate/releases";
    license = lib.licenses.zlib;
  };
})
