{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-headless-client";
  version = "1.4.3";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "headless-client-${version}";
    hash = "sha256-0Py15R6PZJJ/SMHOgMZGw6ZSfbQirjkTFVAUGk1gDLE=";
    # FIXME: Remove once https://github.com/firezone/firezone/pull/8095 is in
    postFetch = ''
      ${lib.getExe gitMinimal} -C $out apply ${./0000-load-system-ca-certs.patch}
    '';
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4sCqw4wI7HQj795QnS37WAoFV69KQy26REhl+DpfLs0=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "headless-client";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  # Required to run tests
  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "headless-client-(.*)"
    ];
  };

  meta = {
    description = "CLI client for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-headless-client";
  };
}
