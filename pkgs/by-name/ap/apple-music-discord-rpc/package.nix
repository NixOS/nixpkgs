{
  lib,
  stdenv,
  fetchFromGitHub,
  deno,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "apple-music-discord-rpc";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "NextFire";
    repo = "apple-music-discord-rpc";
    rev = finalAttrs.version;
    hash = "sha256-o3oJq9IYlW022g8jL1nlVwkuLkrAt/rq38iHp+5eQok=";
  };

  buildInputs = [ deno ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp music-rpc.ts $out/bin

    mkdir -p $out/Library/LaunchAgents
    cp scripts/moe.yuru.music-rpc.plist $out/Library/LaunchAgents
    /usr/bin/plutil -replace EnvironmentVariables.PATH -string "${deno}/bin:/usr/bin" $out/Library/LaunchAgents/moe.yuru.music-rpc.plist
    /usr/bin/plutil -replace ProgramArguments -array $out/Library/LaunchAgents/moe.yuru.music-rpc.plist
    /usr/bin/plutil -insert ProgramArguments -string "$out/bin/music-rpc.ts" -append $out/Library/LaunchAgents/moe.yuru.music-rpc.plist
    /usr/bin/plutil -replace StandardErrorPath -string "~/Library/Logs/music-rpc.log" $out/Library/LaunchAgents/moe.yuru.music-rpc.plist
    /usr/bin/plutil -replace WorkingDirectory -string "~/Library/Application Support/moe.yuru.music-rpc" $out/Library/LaunchAgents/moe.yuru.music-rpc.plist

    runHook postInstall
  '';

  meta = {
    description = "Discord RPC for Apple Music and iTunes";
    homepage = "https://github.com/NextFire/apple-music-discord-rpc";
    downloadPage = "https://github.com/NextFire/apple-music-discord-rpc/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/NextFire/apple-music-discord-rpc/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valentinegb ];
    mainProgram = "music-rpc.ts";
    platforms = lib.platforms.darwin;
  };
})
