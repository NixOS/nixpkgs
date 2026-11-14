{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iceoryx2-cli";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eclipse-iceoryx";
    repo = "iceoryx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BTLt6HEQbiOC3NdYKqnlg1XOYFZrH/WZtTDAiM+9uuo=";
  };

  buildAndTestSubdir = "iceoryx2-cli";
  cargoHash = "sha256-2CoBxHqefPIalvS9hpny11JbaqMBkOAYMMM/kxhcIlo=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Tests mutate PATH and fail when run in parallel
  dontUseCargoParallelTests = true;

  # `iox2 <command>` only looks for `iox2-<command>` in PATH. Keep the commands of this package in
  # libexec and put that on PATH, so they are found without being installed into a profile and
  # are not listed twice when they are
  postInstall = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    mkdir -p $out/libexec/iceoryx2-cli
    mv $out/bin/iox2-* $out/libexec/iceoryx2-cli/
    wrapProgram $out/bin/iox2 \
      --prefix PATH : $out/libexec/iceoryx2-cli
  '';

  meta = {
    description = "CLI tooling for interacting with iceoryx2 systems";
    longDescription = ''
      Command-line tools for interacting with systems built on
      [iceoryx2](https://iceoryx.io), a zero-copy and lock-free inter-process
      communication middleware.
    '';
    homepage = "https://iceoryx.io";
    maintainers = with lib.maintainers; [ shard7 ];
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
    ]
    ++ lib.platforms.darwin
    ++ lib.platforms.windows;
    mainProgram = "iox2";
  };
})
