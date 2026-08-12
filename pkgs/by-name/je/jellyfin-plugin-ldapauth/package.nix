{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-ldapauth";
  version = "23";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-ldapauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-riRanyEFzEvDv09VY5r3Bs2rU2o/Ijsp687KRtnzkSU=";
  };

  projectFile = "LDAP-Auth.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "LDAP authentication provider for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-plugin-ldapauth";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-ldapauth/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
