{ lib
, fetchFromGitHub
, ffmpeg_7-full
, x265
}:

let
  sources = {
    handbrake = {
      pname = "handbrake";
      version = "1.8.0";

      src = fetchFromGitHub {
        owner = "HandBrake";
        repo = "HandBrake";
        # uses version commit for logic in version.txt
        rev = "5edf59c1da54fe1c9a487d09e8f52561fe49cb2a";
        hash = "sha256-gr2UhqPY5mZOP8KBvk9yydl4AkTlqE83hYAcLwSv1Is=";
      };
    };

    # Handbrake maintains a set of ffmpeg patches. In particular, these
    # patches are required for subtitle timing to work correctly.
    # See: https://github.com/HandBrake/HandBrake/issues/4029
    # base ffmpeg version is specified in:
    # https://github.com/HandBrake/HandBrake/blob/master/contrib/ffmpeg/module.defs

    ffmpeg-hb = (ffmpeg_7-full.override {
      version = "7.0";
      hash = "sha256-RdDfv+0y90XpgjIRvTjsemKyGunzDbsh4j4WiE9rfyM=";
    }).overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        "${sources.handbrake.src}/contrib/ffmpeg/A01-mov-read-name-track-tag-written-by-movenc.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A02-movenc-write-3gpp-track-titl-tag.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A03-mov-read-3gpp-udta-tags.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A04-movenc-write-3gpp-track-names-tags-for-all-available.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A05-dvdsubdec-fix-processing-of-partial-packets.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A06-dvdsubdec-return-number-of-bytes-used.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A07-dvdsubdec-use-pts-of-initial-packet.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A08-dvdsubdec-do-not-discard-zero-sized-rects.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A09-ccaption_dec-fix-pts-in-real_time-mode.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A10-matroskaenc-aac-extradata-updated.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A11-videotoolbox-disable-H.264-10-bit-on-Intel-macOS.patch"

        # patch to fix <https://github.com/HandBrake/HandBrake/issues/5011>
        # commented out because it causes ffmpeg's filter-pixdesc-p010le test to fail.
        # "${sources.handbrake.src}/contrib/ffmpeg/A12-libswscale-fix-yuv420p-to-p01xle-color-conversion-bu.patch"

        "${sources.handbrake.src}/contrib/ffmpeg/A13-qsv-fix-decode-10bit-hdr.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A14-amfenc-Add-support-for-pict_type-field.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A15-amfenc-Fixes-the-color-information-in-the-ou.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A16-amfenc-HDR-metadata.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A17-av1dec-dovi-rpu.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A18-avformat-mov-add-support-audio-fallback-track-ref.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A19-mov-ignore-old-infe-box.patch"
        "${sources.handbrake.src}/contrib/ffmpeg/A20-mov-free-infe-on-failure.patch"
      ];
    });

    x265-hb = x265.overrideAttrs (old: {
      # nixpkgs' x265 sourceRoot is x265-.../source whereas handbrake's x265 patches
      # are written with respect to the parent directory instead of that source directory.
      # patches which don't cleanly apply are commented out.
      postPatch = (old.postPatch or "") + ''
        pushd ..
        patch -p1 < ${sources.handbrake.src}/contrib/x265/A01-threads-priority.patch
        patch -p1 < ${sources.handbrake.src}/contrib/x265/A02-threads-pool-adjustments.patch
        patch -p1 < ${sources.handbrake.src}/contrib/x265/A03-sei-length-crash-fix.patch
        patch -p1 < ${sources.handbrake.src}/contrib/x265/A04-ambient-viewing-enviroment-sei.patch
        # patch -p1 < ${sources.handbrake.src}/contrib/x265/A05-memory-leaks.patch
        # patch -p1 < ${sources.handbrake.src}/contrib/x265/A06-crosscompile-fix.patch
        popd
    '';
    });
  };
in
sources
