{
  fetchgit,
}:

let
  nv-codec-headers-template =
    {
      version,
      hash,
    }:
    {
      pname = "nv-codec-headers";
      inherit version;
      src = fetchgit {
        url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
        rev = "n${version}";
        inherit hash;
      };
    };
in
{
  nv-codec-headers-8 = nv-codec-headers-template {
    version = "8.2.15.2";
    hash = "sha256-TKYT8vXqnUpq+M0grDeOR37n/ffqSWDYTrXIbl++BG4=";
  };
  nv-codec-headers-9 = nv-codec-headers-template {
    version = "9.1.23.1";
    hash = "sha256-kF5tv8Nh6I9x3hvSAdKLakeBVEcIiXFY6o6bD+tY2/U=";
  };
  nv-codec-headers-10 = nv-codec-headers-template {
    version = "10.0.26.2";
    hash = "sha256-BfW+fmPp8U22+HK0ZZY6fKUjqigWvOBi6DmW7SSnslg=";
  };
  nv-codec-headers-11 = nv-codec-headers-template {
    version = "11.1.5.2";
    hash = "sha256-KzaqwpzISHB7tSTruynEOJmSlJnAFK2h7/cRI/zkNPk=";
  };
  nv-codec-headers-12 = nv-codec-headers-template {
    version = "12.1.14.0";
    hash = "sha256-WJYuFmMGSW+B32LwE7oXv/IeTln6TNEeXSkquHh85Go=";
  };
}
