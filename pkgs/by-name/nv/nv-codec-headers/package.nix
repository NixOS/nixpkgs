{
  lib,
  fetchgit,
  stdenvNoCC,
}@args:

let
  mkNvCodecHeaders =
    {
      pname ? "nv-codec-headers",
      version,
      hash,
    }:
    args:
    import ./make-nv-codec-headers.nix {
      inherit pname version hash;
    } args;

  v8 =
    (mkNvCodecHeaders {
      version = "8.2.15.2";
      hash = "sha256-TKYT8vXqnUpq+M0grDeOR37n/ffqSWDYTrXIbl++BG4=";
    } args)
    // {
      passthru = {
        inherit versions;
      };
    };

  v9 =
    (mkNvCodecHeaders {
      version = "9.1.23.1";
      hash = "sha256-kF5tv8Nh6I9x3hvSAdKLakeBVEcIiXFY6o6bD+tY2/U=";
    } args)
    // {
      passthru = {
        inherit versions;
      };
    };

  v10 =
    (mkNvCodecHeaders {
      version = "10.0.26.2";
      hash = "sha256-BfW+fmPp8U22+HK0ZZY6fKUjqigWvOBi6DmW7SSnslg=";
    } args)
    // {
      passthru = {
        inherit versions;
      };
    };

  v11 =
    (mkNvCodecHeaders {
      version = "11.1.5.2";
      hash = "sha256-KzaqwpzISHB7tSTruynEOJmSlJnAFK2h7/cRI/zkNPk=";
    } args)
    // {
      passthru = {
        inherit versions;
      };
    };

  v12 =
    (mkNvCodecHeaders {
      version = "12.1.14.0";
      hash = "sha256-WJYuFmMGSW+B32LwE7oXv/IeTln6TNEeXSkquHh85Go=";
    } args)
    // {
      passthru = {
        inherit versions;
      };
    };

  # v9 is default because of ffmpeg and handbrake packages; in the future we
  # should modify them so that they call nv-codec-headers-9 directly instead
  default = v9;
  latest = v12;

  versions = {
    inherit
      v8
      v9
      v10
      v11
      v12
      default
      latest
      ;
  };
in
default
