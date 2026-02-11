{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,

}:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "bandwhich";
    rev = "v${version}";
    hash = "sha256-gXPX5drVXsfkssPMdhqIpFsYNSbelE9mKwO+nGEy4Qs=";
  };

  cargoHash = "sha256-bsyEEbwBTDcIOc+PRkZqcfqcDgQnchuVy8a8eSZZUHU=";

  nativeBuildInputs = [ installShellFiles ];

  __darwinAllowLocalNetworking = true;

  preConfigure = ''
    export BANDWHICH_GEN_DIR=_shell-files
    mkdir -p $BANDWHICH_GEN_DIR
  '';

  postInstall = ''
    installManPage $BANDWHICH_GEN_DIR/bandwhich.1

    installShellCompletion $BANDWHICH_GEN_DIR/bandwhich.{bash,fish} \
      --zsh $BANDWHICH_GEN_DIR/_bandwhich
  '';

  meta = {
    description = "CLI utility for displaying current network utilization";
    longDescription = ''
      bandwhich sniffs a given network interface and records IP packet size, cross
      referencing it with the /proc filesystem on linux or lsof on MacOS. It is
      responsive to the terminal window size, displaying less info if there is
      no room for it. It will also attempt to resolve ips to their host name in
      the background using reverse DNS on a best effort basis.
    '';
    homepage = "https://github.com/imsnif/bandwhich";
    changelog = "https://github.com/imsnif/bandwhich/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [
    ];
    platforms = lib.platforms.unix;
    mainProgram = "bandwhich";
  };
}
