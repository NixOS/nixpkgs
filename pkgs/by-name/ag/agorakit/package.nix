{
  lib,
  fetchFromGitHub,
  php,
  dataDir ? "/var/lib/agorakit",
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "agorakit";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "agorakit";
    repo = "agorakit";
    tag = finalAttrs.version;
    sha256 = "sha256-mBBl/8nXG3FsMeecbERLyY2tGFhh+5nS8A4nd7HI+8c=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R * $out
    rm -rf $out/storage
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/storage $out/storage
    runHook postInstall
  '';

  vendorHash = "sha256-PBymOrvorGfByTBVu/r+kBxQya5qIlu07mfu4ttT7xs=";
  composerStrictValidation = false;

  meta = {
    description = "Web-based, open-source groupware";
    longDescription = "AgoraKit is web-based, open-source groupware for citizens' initiatives. By creating collaborative groups, people can discuss topics, organize events, store files and keep everyone updated as needed. AgoraKit is a forum, calendar, file manager and email notifier.";
    homepage = "https://github.com/agorakit/agorakit";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
  };
})
