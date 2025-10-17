{
  ffmpeg_7-full,
  fetchFromGitHub,
  fetchpatch2,
  lib,
}:

let
  version = "7.1.2-2";
in

(ffmpeg_7-full.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    hash = "sha256-0dUQ/3843wWpb10XZl3ddCbjjbFGWh3eoNH4EuWSQiQ=";
  };
}).overrideAttrs
  (old: {
    pname = "jellyfin-ffmpeg";

    configureFlags = old.configureFlags ++ [
      "--extra-version=Jellyfin"
      "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
    ];

    # Clobber upstream patches as they don't apply to the Jellyfin fork
    patches = [
      (fetchpatch2 {
        name = "lcevcdec-4.0.0-compat.patch";
        url = "https://code.ffmpeg.org/FFmpeg/FFmpeg/commit/fa23202cc7baab899894e8d22d82851a84967848.patch";
        hash = "sha256-Ixkf1xzuDGk5t8J/apXKtghY0X9cfqSj/q987zrUuLQ=";
      })
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
      maintainers = with lib.maintainers; [ justinas ];
      pkgConfigModules = [ "libavutil" ];
    };
  })
