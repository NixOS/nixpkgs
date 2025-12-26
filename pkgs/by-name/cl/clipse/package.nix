{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "clipse";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-17ZzmgXm8aJGG4D48wJv+rBCvJZMH3b2trHwhTqwb8s=";
  };

  vendorHash = "sha256-6lOUSRo1y4u8+8G/L6BvhU052oYrsthqxrsgUtbGhYM=";

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = [ lib.maintainers.savedra1 ];
  };

  wayland = buildGoModule {
    inherit pname version src vendorHash meta;

    env = {
      CGO_ENABLED = "0";
    };

    tags = [ "wayland" ];
  };

  x11 = buildGoModule {
    pname = "${pname}-x11";
    inherit version src vendorHash meta;

    env = {
      CGO_ENABLED = "1";
    };

    tags = [ "linux" ];
  };

  darwin = buildGoModule {
    pname = "${pname}-darwin";
    inherit version src vendorHash meta;

    env = {
      CGO_ENABLED = "1";
    };

    tags = [ "darwin" ];
  };

in
wayland // {
  passthru.x11 = x11;
  passthru.darwin = darwin;
}
