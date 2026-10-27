{
  vimUtils,
  hurl,
}:
vimUtils.buildVimPlugin {
  pname = "hurl";
  inherit (hurl) version;

  # https://hurl.dev/
  src = "${hurl.src}/contrib/vim";

  meta = {
    inherit (hurl.meta)
      description
      homepage
      changelog
      maintainers
      license
      ;
  };
}
