# Astal {#astal}

Astal is a collection of building blocks for creating custom desktop shells.

## Bundling {#astal-bundling}

Bundling an Astal application is done using the `ags` tool. You can use it like this:

```nix
ags.bundle {
  pname = "hyprpanel";
  version = "1.0.0";

  src = fetchFromGitHub {
    #...
  };

  # change your entry file (default is `app.ts`)
  entry = "app.ts";

  dependencies = [
    # list here astal modules that your package depends on
    # `astal3`, `astal4` and `astal.io` are automatically included
    astal.apps
    astal.battery
    astal.bluetooth

    # you can also list here other runtime dependencies
    hypridle
    hyprpicker
    hyprsunset
  ];

  # GTK 4 support is opt-in
  enableGtk4 = true;

  meta = {
    #...
  };
}
```

You can also pass all other arguments that are supported by `stdenv.mkDerivation`.
