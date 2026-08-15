{
  lib,
  buildGoModule,
}:

buildGoModule {
  name = "hello-go";

  src = ./src;

  vendorHash = null;

  env.CGO_ENABLED = 0;

  # go installs binary into $out/bin/$GOOS_$GOARCH/hello-go in cross compilation
  postInstall = ''
    [[ -f "$out/bin/hello-go" ]] || ln -s ./''${GOOS}_''${GOARCH}/hello-go $out/bin/hello-go
  '';

  meta = {
    description = "Simple program printing hello world in Go";
    longDescription = ''
      hello-go is a simple program printing "Hello, world!" written in Go,
      aiming at testing programs that involves analyzing executables or
      emulating foreign architectures, without pulling in a heavy cross
      toolchain.

      Specify target platform by setting GOOS and GOARCH:

      ```nix
      hello-go.overrideAttrs (previousAttrs: {
        env = previousAttrs.env or { } // {
          GOOS = "linux";
          GOARCH = "arm64";
        };
      })
      ```

      See https://pkg.go.dev/internal/platform#pkg-variables for a list
      of available platforms.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "hello-go";
  };
}
