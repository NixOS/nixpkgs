{
  ffmpeg_7-full,
  fetchFromGitHub,
  lib,
}:

let
  version = "7.1.2-1";
in

(ffmpeg_7-full.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    hash = "sha256-1nisdEtH5J5cDqUeDev0baCHopmoQ1SEojFdYdYeY0Q=";
  };
}).overrideAttrs
  (old: {
    pname = "jellyfin-ffmpeg";

    configureFlags = old.configureFlags ++ [
      "--extra-version=Jellyfin"
      "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
    ];

    # Clobber upstream patches as they don't apply to the Jellyfin fork
    patches = [ ];

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
      maintainers = with lib.maintainers; [ justinas ];
      pkgConfigModules = [ "libavutil" ];
    };
  })
