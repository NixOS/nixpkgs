{ lib
, rustPlatform
, fetchFromGitHub
, python3
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nickel";
    rev = "refs/tags/${version}";
    hash = "sha256-mjmT1ogvUJgy3Jb6m/npE+1if1Uy191wPU80nNlVwdM=";
  };

  cargoHash = "sha256-XDDvuIVWvmsO09aQLF28OyH5n+9aO5J+89EQLru7Jrc=";

  cargoBuildFlags = [ "-p nickel-lang-cli" "-p nickel-lang-lsp" ];

  nativeBuildInputs = [
    python3
  ];

  outputs = [ "out" "nls" ];

  postInstall = ''
    mkdir -p $nls/bin
    mv $out/bin/nls $nls/bin/nls
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://nickel-lang.org/";
    description = "Better configuration for less";
    longDescription = ''
      Nickel is the cheap configuration language.

      Its purpose is to automate the generation of static configuration files -
      think JSON, YAML, XML, or your favorite data representation language -
      that are then fed to another system. It is designed to have a simple,
      well-understood core: it is in essence JSON with functions.
    '';
    changelog = "https://github.com/tweag/nickel/blob/${version}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres felschr matthiasbeyer ];
    mainProgram = "nickel";
  };
}
