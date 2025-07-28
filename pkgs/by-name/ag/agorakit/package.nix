{
  lib,
  fetchFromGitHub,
  php82,
  nix-update-script,
  dataDir ? "/var/lib/agorakit",
}:

php82.buildComposerProject2 (finalAttrs: {
  pname = "agorakit";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "agorakit";
    repo = "agorakit";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-YCHszRi+atEkaM9bHncpRtQsuiS6P22yKSqYzXq8flk=";
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

  vendorHash = "sha256-tBB3Zl/N1XqPTD84at5WoGrD0G5rJbobk4E8BFOSm+M=";
  composerStrictValidation = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web-based, open-source groupware";
    longDescription = "AgoraKit is web-based, open-source groupware for citizens' initiatives. By creating collaborative groups, people can discuss topics, organize events, store files and keep everyone updated as needed. AgoraKit is a forum, calendar, file manager and email notifier.";
    homepage = "https://github.com/agorakit/agorakit";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = with lib.teams; [ ngi ];
  };
})
