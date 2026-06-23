{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "appwrite-cli";
  version = "15.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "appwrite";
    repo = "sdk-for-cli";
    tag = finalAttrs.version;
    hash = "sha256-fjR6TWKi3lSnZL52tPwrFZ/PYNknQyrfScWsvgAUaas=";
  };

  npmDepsHash = "sha256-8H0wv6rveRUDIBY6BGc6VuAtEvmjOfX/ODB8P7nozaY=";

  meta = {
    description = "Official Appwrite CLI";
    homepage = "https://appwrite.io";
    changelog = "https://github.com/appwrite/sdk-for-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "appwrite";
    maintainers = with lib.maintainers; [ mikeee ];
    platforms = lib.platforms.unix;
  };
})
