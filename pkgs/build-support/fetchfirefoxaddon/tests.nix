{ invalidateFetcherByDrvHash, fetchFirefoxAddon, ... }:

{
  simple = invalidateFetcherByDrvHash fetchFirefoxAddon {
    name = "image-search-options";
    # Chosen because its only 147KB
    url = "https://addons.mozilla.org/firefox/downloads/file/3059971/image_search_options-3.0.12-fx.xpi";
    sha256 = "sha256-H73YWX/DKxvhEwKpWOo7orAQ7c/rQywpljeyxYxv0Gg=";
  };
}
