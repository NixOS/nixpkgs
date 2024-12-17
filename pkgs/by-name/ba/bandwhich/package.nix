{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,

  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gXPX5drVXsfkssPMdhqIpFsYNSbelE9mKwO+nGEy4Qs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bsyEEbwBTDcIOc+PRkZqcfqcDgQnchuVy8a8eSZZUHU=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security;

  # 10 passed; 47 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.hostPlatform.isDarwin;

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
    maintainers = with lib.maintainers; [
      Br1ght0ne
      figsoda
    ];
    platforms = lib.platforms.unix;
    mainProgram = "bandwhich";
  };
}
