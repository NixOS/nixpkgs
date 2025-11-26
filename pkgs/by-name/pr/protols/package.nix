{
  lib,
  pkgs,
  makeWrapper,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-WHVvcTWMpID6Yxi3/ZEnslZQTphp8ew0U05GTmdBMeg=";
  };

  cargoHash = "sha256-10DU8/j9+LvT42r4Hyk0kdgQHEtDrZ4FZBQwlSGapPw=";

  nativeBuildInputs = [ makeWrapper ];

  # protols requires *.proto files provided by protobuf for well-known imports
  # (go to definition and linting) and uses a detection mechanism based on
  # pkg-config to find the directory containing the relevant files in runtime.
  #
  # This is sub-optimal, because:
  # - it requires pkg-config and protobuf.pc(+deps) as runtime dependencies,
  # - the set of include paths it finds is non-minimal.
  #
  # We don't provide pkg-config or protobuf as dependencies, hoping for this
  # detection to fail silently. Instead, the directory path containing the
  # relevant *.proto files is passed as an include path.
  postFixup = ''
    wrapProgram $out/bin/protols \
      --add-flag "--include-paths" \
      --add-flag "${pkgs.protobuf}/include"
  '';

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
