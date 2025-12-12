{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
}:

buildGoModule rec {
  pname = "3mux";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = "3mux";
    tag = "v${version}";
    sha256 = "sha256-QT4QXTlJf2NfTqXE4GF759EoW6Ri12lxDyodyEFc+ag=";
  };

  patches = [
    # Needed so that the subsequent patch applies.
    (fetchpatch {
      name = "use-shorter-uuids.patch";
      url = "https://github.com/aaronjanse/3mux/commit/6dd36694586f96e3c82ef7db1a0e7917ceb05794.patch";
      hash = "sha256-FnFupOIIQi66mvjshn3EQ6XRzC4cLx3vGTeTUM1HOwM=";
    })
    # Fix the build for Darwin when building with Go 1.18.
    # https://github.com/aaronjanse/3mux/pull/127
    (fetchpatch {
      name = "darwin-go-1.18-fix.patch";
      url = "https://github.com/aaronjanse/3mux/commit/f2c26c1037927896d6e9a17ea038f8260620fbd4.patch";
      hash = "sha256-RC3p30r0PGUKrxo8uOLL02oyfLqLfhNjBYy6E+OQ2f0=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-KMcl6mj+cEgvdZMzBxUtGJsgwPdFuXrY3yjmkB3CS4o=";

  # This is a package used for internally testing 3mux. It's meant for
  # use by 3mux maintainers/contributors only.
  excludedPackages = [ "fuzz" ];

  # 3mux needs to have itself in the path so users can run `3mux detach`.
  # This ensures that, while inside 3mux, the binary in the path is the
  # same version as the 3mux hosting the session. This also allows users
  # to use 3mux via `nix run nixpkgs#_3mux` (otherwise they'd get "command
  # not found").
  postInstall = ''
    wrapProgram $out/bin/3mux --prefix PATH : $out/bin
  '';

  meta = {
    description = "Terminal multiplexer inspired by i3";
    mainProgram = "3mux";
    longDescription = ''
      Terminal multiplexer with out-of-the-box support for search,
      mouse-controlled scrollback, and i3-like keybindings
    '';
    homepage = "https://github.com/aaronjanse/3mux";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aaronjanse
    ];
    platforms = lib.platforms.unix;
  };
}
