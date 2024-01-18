{
  stable = import ./browser.nix {
    channel = "stable";
    version = "120.0.2210.77";
    revision = "1";
    hash = "sha256-mSIx/aYutmA/hGycNapvm8/BnADtXA6NRlMmns+yM5k=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "121.0.2277.4";
    revision = "1";
    hash = "sha256-Qn0H5JUMZUASqfaJfM1cpKj9E6XHjArvZ3jE+GpREOs=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "121.0.2277.4";
    revision = "1";
    hash = "sha256-41hOoZANy5hWrHAzxZGLX69apNMoAn7PiarWl6wicPA=";
  };
}
