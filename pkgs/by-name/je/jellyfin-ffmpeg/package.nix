{
  ffmpeg_8-full,
  fetchFromGitHub,
  lib,
}:

let
  version = "8.1.2-4";
in

(ffmpeg_8-full.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    tag = "v${version}";
    hash = "sha256-+xUjwhVX/HyS/+Gmv8iQfUwHax7xjX3SSOjs34IDHHs=";
  };
  buildFfplay = false; # requires SDL2 which gets disabled
  buildFfprobe = true; # required by various programs like Immich
  withSamba = false; # samba is rather big and unused
  withSdl2 = false;
}).overrideAttrs
  (old: {
    pname = "jellyfin-ffmpeg";

    configureFlags = old.configureFlags ++ [
      "--extra-version=Jellyfin"
    ];

    postPatch = ''
      for file in $(cat debian/patches/series); do
        patch -p1 < debian/patches/$file
      done

      ${old.postPatch or ""}
    '';

    meta = {
      inherit (old.meta) license mainProgram;
      changelog = "https://github.com/jellyfin/jellyfin-ffmpeg/releases/tag/v${version}";
      description = "${old.meta.description} (Jellyfin fork)";
      homepage = "https://github.com/jellyfin/jellyfin-ffmpeg";
      maintainers = with lib.maintainers; [
        dotlambda
        justinas
      ];
      pkgConfigModules = [ "libavutil" ];
    };
  })
