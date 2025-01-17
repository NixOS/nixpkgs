{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-gateway";
  version = "1.4.3";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gateway-${version}";
    hash = "sha256-BXfEQ5KQMZDiHgMr9+rfI650qeDeF1TgKIqFShz2Ztc=";
    # FIXME: Remove once https://github.com/firezone/firezone/pull/8095 is in
    postFetch = ''
      ${lib.getExe gitMinimal} -C $out apply ${./0000-load-system-ca-certs.patch}
    '';
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5L8jhT4qoF6gkSW0TD+fe114Kl/BZvVaFA5UoqQWudc=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "gateway";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "gateway-(.*)"
    ];
  };

  meta = {
    description = "WireGuard tunnel server for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-gateway";
  };
}
