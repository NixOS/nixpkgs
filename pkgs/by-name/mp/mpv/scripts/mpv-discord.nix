{
  fetchFromGitHub,
  buildGoModule,
  buildLua,
  lib,
}:
let
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "tnychn";
    repo = "mpv-discord";
    rev = "v${version}";
    hash = "sha256-P1UaXGboOiqrXapfLzJI6IT3esNtflkQkcNXt4Umukc=";
  };

  core = buildGoModule {
    name = "mpv-discord-core";
    inherit version;

    src = "${src}/mpv-discord";

    vendorHash = "sha256-xe1jyWFQUD+Z4qBAVQ0SBY0gdxmi5XG9t29n3f/WKDs=";
  };
in
buildLua {
  pname = "mpv-discord";
  inherit version src;

  scriptPath = "scripts/discord.lua";

  postInstall = ''
    substituteInPlace $out/share/mpv/scripts/discord.lua \
      --replace-fail 'binary_path = ""' 'binary_path = "${core}/bin/mpv-discord"'
  '';

  meta = {
    description = "Cross-platform Discord Rich Presence integration for mpv with no external dependencies";
    homepage = "https://github.com/tnychn/mpv-discord";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bddvlpr ];
  };
}
