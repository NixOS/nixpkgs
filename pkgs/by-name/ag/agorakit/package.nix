{
  lib,
  fetchFromGitHub,
  php,
  nix-update-script,
  dataDir ? "/var/lib/agorakit",
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "agorakit";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "agorakit";
    repo = "agorakit";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-1OLH65Hp9bmhqPFjU8K5xmMyWzqScjJDcuqpfZHQoSw=";
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

  vendorHash = "sha256-iwVmxsadA/HrNbJcsB1q21BINSSwPrBiwE3ztw/smvo=";
  composerStrictValidation = false;

  passthru = {
    tests = { inherit (nixosTests) agorakit; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web-based, open-source groupware";
    longDescription = ''
      AgoraKit is web-based, open-source groupware for citizens' initiatives.
      By creating collaborative groups, people can discuss topics, organize events, store files and keep everyone updated as needed.
      AgoraKit is a forum, calendar, file manager and email notifier.
    '';
    homepage = "https://github.com/agorakit/agorakit";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = with lib.teams; [ ngi ];
  };
})
