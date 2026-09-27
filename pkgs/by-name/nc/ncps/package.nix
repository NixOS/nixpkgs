{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  nixosTests,
  xz,
}:

buildGoModule (finalAttrs: {
  pname = "ncps";
  version = "0.10.0-rc16";

  src = fetchFromGitHub {
    owner = "kalbasit";
    repo = "ncps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b8cYpPkJYmt0WJiTtuSsNqbGKViok6zPHpQHTBc9wZc=";
  };

  vendorHash = "sha256-vhwuUkqU9oWHtKT3BELa1v+QPmYsw+11AK/1KMtO9l0=";

  ldflags = [
    "-X github.com/kalbasit/ncps/pkg/ncps.Version=v${finalAttrs.version}"
  ];

  # The dev tooling under cmd/ (ent-lint, generate-migrations, atlas-sum-check)
  # are all `package main`; exclude them so they are neither built as stray
  # binaries nor run during the check phase. The ncps binary lives at the repo
  # root, so it is unaffected.
  excludedPackages = [ "cmd" ];

  buildInputs = [ xz ];

  nativeBuildInputs = [
    makeWrapper # used for wrapping the binary so it can always find the xz binary
  ];

  postInstall = ''
    # ncps makes use of xz for decompression as it's 3-5x faster than
    # using the native Go implementation of xz. By wrapping ncps, and
    # setting the XZ_BINARY_PATH environment variable, we ensure that
    # ncps can always find the xz binary. This environment variable is
    # read by a flag in pkg/ncps and can be overriden by using calling
    # ncps with the --xz-binary-path flag.
    wrapProgram $out/bin/ncps --set XZ_BINARY_PATH ${lib.getExe' xz "xz"}
  '';

  doCheck = true;

  checkFlags = [ "-race" ];

  passthru = {
    tests = {
      inherit (nixosTests)
        ncps
        ncps-custom-sqlite-directory
        ncps-custom-storage-local
        ncps-ha-pg-redis
        ncps-ha-pg-redis-cdc
        ;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nix binary cache proxy service";
    homepage = "https://github.com/kalbasit/ncps";
    license = lib.licenses.mit;
    mainProgram = "ncps";
    maintainers = with lib.maintainers; [
      kalbasit
      aciceri
    ];
  };
})
