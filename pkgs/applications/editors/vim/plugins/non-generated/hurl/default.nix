{
  vimUtils,
  hurl,
}:
vimUtils.buildVimPlugin {
  pname = "hurl";
  inherit (hurl) version;

  # https://hurl.dev/
  src = "${hurl.src}/contrib/vim";
}
