{
  lib,
  fetchFromGitHub,
  maven,
  nix-update-script,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-magic-link";
  version = "0.38";

  src = fetchFromGitHub {
    owner = "p2-inc";
    repo = "keycloak-magic-link";
    tag = "v${version}";
    hash = "sha256-+fhWxAUlt9UVM81Ua2Mwek3D5Kzzk/Tsugbo0fLyxiA=";
  };

  mvnHash = "sha256-edBdooR+KqY0JKwxdwTd5AxJ0qn3MV9xLrqYukIq2oY=";

  installPhase = ''
    runHook preInstall
    install -Dm644 target/keycloak-magic-link-${version}.jar $out/keycloak-magic-link-${version}.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/p2-inc/keycloak-magic-link";
    description = "Magic Link Authentication for Keycloak";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
