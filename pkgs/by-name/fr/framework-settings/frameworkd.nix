{
  lib,
  pkg-config,
  rustPlatform,
  libgit2,
  udev,

  src,
  version,
}:

rustPlatform.buildRustPackage {
  pname = "frameworkd";
  inherit src version;
  sourceRoot = "${src.name}/daemon";

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-9ij55dKL6GAcSB+Dh5GsorjF5GWYvdeF1FHMKmT3R+8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgit2
    udev
  ];

  meta = {
    description = "DBus daemon for framework configuration";
    homepage = "https://github.com/flamingspaz/framework-settings";
    license = lib.licenses.gpl3Plus;
    mainProgram = "frameworkd";
    platforms = lib.platforms.linux;
  };
}
