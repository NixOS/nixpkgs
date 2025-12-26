{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  enableWayland ? true,
  enableX11 ? false,
}:

let
  pname = "clipse";
  version = "1.2.0";

  tags =
    if stdenv.hostPlatform.isDarwin then
      [ "darwin" ]
    else if enableWayland then
      [ "wayland" ]
    else if enableX11 then
      [ "linux" ]
    else
      [ ];

  cgoEnabled = enableX11 || stdenv.hostPlatform.isDarwin;

  packageName = if enableX11 then "${pname}-x11" else pname;
in
(
  assert lib.assertMsg (
    stdenv.hostPlatform.isLinux -> (lib.xor enableX11 enableWayland)
  ) "Exactly one of enableWayland, enableX11 must be true";

  buildGoModule {
    pname = packageName;
    inherit version;

    src = fetchFromGitHub {
      owner = "savedra1";
      repo = "clipse";
      rev = "v${version}";
      hash = "sha256-17ZzmgXm8aJGG4D48wJv+rBCvJZMH3b2trHwhTqwb8s=";
    };

    vendorHash = "sha256-6lOUSRo1y4u8+8G/L6BvhU052oYrsthqxrsgUtbGhYM=";

    inherit tags;

    env = {
      CGO_ENABLED = if cgoEnabled then "1" else "0";
    };

    meta = {
      description = "Useful clipboard manager TUI for Unix";
      homepage = "https://github.com/savedra1/clipse";
      license = lib.licenses.mit;
      mainProgram = "clipse";
      maintainers = [ lib.maintainers.savedra1 ];
    };
  }
)
