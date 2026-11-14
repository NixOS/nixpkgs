{ imlib2, stdenv }:

imlib2.override {
  # Compilation error on Darwin with librsvg. For more information see:
  # https://github.com/NixOS/nixpkgs/pull/166452#issuecomment-1090725613
  svgSupport = !stdenv.hostPlatform.isDarwin;
  heifSupport = !stdenv.hostPlatform.isDarwin;
  webpSupport = true;
  jxlSupport = true;
  psSupport = true;
  j2kSupport = true;
}
