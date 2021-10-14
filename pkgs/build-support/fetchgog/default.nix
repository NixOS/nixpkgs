{ requireFile }:

# How to find slug:
# Go to the downloads page on your GOG account, hover over the game installer
# download link, and check the part of the path following "downloads/".
{ slug, filename, sha256 }:
requireFile rec {
  name = filename;
  inherit sha256;
  url = "https://www.gog.com/downloads/${slug}/en3installer0";
  message = ''
    Unfortunately, we cannot download ${slug} (${filename}) from GOG
    automatically. Please go to ${url} to sign in to GOG and download it
    yourself, and add it to the Nix store using
      nix-store --add-fixed sha256 ${filename}
  '';
}
