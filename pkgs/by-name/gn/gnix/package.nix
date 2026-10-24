{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "gnix";
  version = "v2.6.0";

  src = fetchFromCodeberg {
    owner = "metamuffin";
    repo = "gnix";
    tag = finalAttrs.version;
    hash = "sha256-3kA8vEE4rN23ke+bBxjgTBCfk+NMYJjnTHM8xtiaCiw=";
  };

  cargoHash = "sha256-CxUiBms8m0cYDPuhrJQIP36mpgmSGkWxnElw1UHFy5Y=";

  meta = {
    description = " A simple stupid reverse proxy";
    homepage = "https://codeberg.org/metamuffin/gnix";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      kleiner3
    ];

    # tested on, probably works on more
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
