generic: {
  v4 = generic {
    version = "4.0.0";
    hash = "sha256-864Mohxfc3EchBKtSNifxy8g8T8YBUQ/H7+8Ti6TiFo=";
    patches = [
      # Look for plugin-related files in $out/lib/rofi
      ./0001-Patch-plugindir-to-output.patch
    ];
  };
  v3 = generic {
    version = "3.4.1";
    hash = "sha256-ZHhgYytPB14zj2MS8kChRD+LTqXzHRrz7YIikuQD6i0=";
    patches = [
      # Look for plugin-related files in $out/lib/rofi
      ./0001-Patch-plugindir-to-output.patch
    ];
  };
}
