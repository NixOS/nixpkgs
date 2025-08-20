{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  valgrind,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    tag = version;
    sha256 = "sha256-yUCDKklkfK+2n+THH4QlHb+FpeWfObXpmp4VozsFiUM=";
  };

  cargoHash = "sha256-6vcTsernIVkemGhMBT9LMTsBsJ4u1Sd12BgIp4Zn3vg=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-valgrind --prefix PATH : ${lib.makeBinPath [ valgrind ]}
  '';

  checkFlags = [
    "--skip examples_are_runnable"
    "--skip tests_are_runnable"
    "--skip issue74"
  ];

  meta = with lib; {
    description = ''Cargo subcommand "valgrind": runs valgrind and collects its output in a helpful manner'';
    mainProgram = "cargo-valgrind";
    homepage = "https://github.com/jfrimmel/cargo-valgrind";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      otavio
      matthiasbeyer
    ];
  };
}
