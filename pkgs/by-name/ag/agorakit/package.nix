{
  lib,
  fetchFromGitHub,
  php,
  dataDir ? "/var/lib/agorakit",
}:

php.buildComposerProject (finalAttrs: {
  pname = "agorakit";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-6T7AksvBxUpv8TkPicnlCE5KZS/ydPB5Bq1MJcWoZds=";
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

  vendorHash = "sha256-5ypBA9Qb8jHzAtvNBHkJfsLIf3Pfw1LvYmHP/hED2ig=";
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
