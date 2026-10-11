{ lib }:

let
  pkgVersion = "8.3.27.1606";
  versionParts = lib.versions.splitVersion pkgVersion;
  versionShort = builtins.concatStringsSep "." (lib.take 3 versionParts);
  versionBuild = builtins.elemAt versionParts 3;
  pkgVersionStr = "${versionShort}-${versionBuild}";
in {
  inherit pkgVersion versionShort versionBuild pkgVersionStr;

  commonDebInfo = {
    name = "1c-enterprise-${pkgVersion}-common_${pkgVersionStr}_amd64.deb";
    url = "https://releases.1c.ru/project/Platform83";
    sha256 = "sha256-PGjttk+GIum/4yp9rwG5iRXhIkUkP35bNP2hVUpDB5s=";
  };

  clientDebInfo = {
    name = "1c-enterprise-${pkgVersion}-client_${pkgVersionStr}_amd64.deb";
    url = "https://releases.1c.ru/project/Platform83";
    sha256 = "sha256-gTylZZNYM7mSxqwKGDQktF8swBl1cSkHIC0K833cnhQ=";
  };

  serverDebInfo = {
    name = "1c-enterprise-${pkgVersion}-server_${pkgVersionStr}_amd64.deb";
    url = "https://releases.1c.ru/project/Platform83";
    sha256 = "sha256-l4vibq5/V78CgDwoIFJnS4PC2chXfPEyvOrcVnq+KNg=";
  };
}