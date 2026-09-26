{
  lib,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule (finalAttrs: {
  pname = "release-notes-assistant";
  version = "1.7.3";

  src = fetchFromGitea {
    owner = "forgejo";
    repo = "release-notes-assistant";
    rev = "v${finalAttrs.version}";
    domain = "code.forgejo.org";
    hash = "sha256-EN4FD2mFaN4jN34e6RfPovYeMnY3/Yd8JWSFVw/f+7Y=";
  };

  doCheck = false;

  __structuredAttrs = true;

  vendorHash = "sha256-93kN2QP/6Z8J6Z7O+BjhocEcT4A7IqDAfzbl9OxAHFM=";

  meta = {
    description = " Create or update release notes based on the repository and the pull requests";
    platforms = lib.platforms.linux;
    mainProgram = "release-notes-assistant";
    homepage = "https://code.forgejo.org/forgejo/release-notes-assistant";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      orzklv
      bahrom04
      wolfram444
    ];
  };
})
