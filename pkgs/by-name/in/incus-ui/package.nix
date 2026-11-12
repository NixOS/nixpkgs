{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:

buildNpmPackage {
  pname = "incus-ui";
  #version = "0.1";
  version = "0-unstable-2026-11-05";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus-ui";
    #tag = "v-${finalAttrs.version}";
    rev = "90c8a42abba08e7eb646dbbfc195080cefd789b8";
    hash = "sha256-s1XPV/lzVnzY2VDjfUE90/PU/X+YAxWsi+opyI/Gq6k=";
  };

  npmDepsHash = "sha256-52orxwT4s54TzyQCPhK5GxwCn4+e0FPCORDfcXL0ibk=";

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/. $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Incus web UI";
    homepage = "https://github.com/zabbly/incus-ui-canonical";
    #changelog = "https://github.com/zabbly/incus-ui-canonical/-/releases/${finalAttrs.src.tag}"
    license = lib.licenses.asl20;
    teams = [ lib.teams.lxc ];
    platforms = lib.platforms.linux;
  };
}
