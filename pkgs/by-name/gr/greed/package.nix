{
  lib,
  fetchFromGitLab,
  gitUpdater,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "greed";
  version = "5.2";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "greed";
    tag = finalAttrs.version;
    hash = "sha256-zhbx+4ZtsIAVfQ99FndLwGWnqf4QeZHDBUynBDFVssM=";
  };

  cargoHash = "sha256-AT7o6uMdV6NtsbZwjh/r9OUMH7glaOeFfMvMJxVwXtA=";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/games/lib/greed.hs" "/var/lib/greed/greed.hs"
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "http://www.catb.org/~esr/";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    description = "Game of Consumption";
    changelog = "https://gitlab.com/esr/greed/-/blob/${finalAttrs.version}/NEWS.adoc?ref_type=tags";
    mainProgram = "greed";
  };
})
