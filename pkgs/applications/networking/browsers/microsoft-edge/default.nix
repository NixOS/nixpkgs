{
  beta = import ./browser.nix {
    channel = "beta";
    version = "129.0.2792.52";
    revision = "1";
    hash = "sha256-KurkG/OxoKOcBcFXj9xhQVSidc2L6bzrDY8c2OmSQro=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "130.0.2835.2";
    revision = "1";
    hash = "sha256-szxMnqw7tUvASsxsYacrQ3StofUJHBWHIhF3EfGIVAs=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "129.0.2792.52";
    revision = "1";
    hash = "sha256-tiq6PwDrH8ZctfyDza9W3WOsj7NArv4XyMPGWU7fW7A=";
  };
}
