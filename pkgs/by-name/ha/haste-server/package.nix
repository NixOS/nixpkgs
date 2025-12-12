{
  lib,
  nixosTests,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "haste-server";
  version = "unstable-2023-03-06";

  src = fetchFromGitHub {
    owner = "toptal";
    repo = "haste-server";
    rev = "b52b394bad909ddf151073987671e843540d91d6";
    hash = "sha256-AVoz5MY5gNxQrHtDMPbQ85IjmHii1v6C2OXpEQj9zC8=";
  };

  npmDepsHash = "sha256-FEuqKbblAts0WTnGI9H9bRBOwPvkahltra1zl3sMPJs=";

  dontNpmBuild = true;

  postInstall = ''
    install -Dt "$out/share/haste-server" about.md
    rm -rf "$out/lib/node_modules/haste/node_modules/.bin/"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) haste-server;
    };
  };

  meta = {
    description = "Open source pastebin written in Node.js";
    homepage = "https://github.com/toptal/haste-server";
    license = lib.licenses.mit;
    mainProgram = "haste-server";
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
}
