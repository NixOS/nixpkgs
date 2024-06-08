{
  lib,
  stdenvNoCC,
  fetchurl,
  zlib,
  openssl,
  gmpxx,
  buildFHSEnv,
}:
let
  simplex-chat = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "simplex-chat";
    version = "5.8.0";

    src = fetchurl {
      url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${finalAttrs.version}/simplex-chat-ubuntu-22_04-x86-64";
      hash = "sha256-L4vf71OjfZkjd0Ula5/eV5WCxYuI3eE7wKAFclyjEwE=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 $src $out/bin/simplex-chat

      runHook postInstall
    '';

    meta = {
      description = "Terminal application for SimpleX Chat";
      mainProgram = "simplex-chat";
      homepage = "https://simplex.chat";
      changelog = "https://github.com/simplex-chat/simplex-chat/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ drupol ];
      platforms = [ "x86_64-linux" ];
    };
  });
in
buildFHSEnv {
  inherit (simplex-chat) pname version meta;

  targetPkgs = pkgs: [
    simplex-chat
    openssl
    gmpxx
    zlib
  ];

  runScript = "simplex-chat";
}
