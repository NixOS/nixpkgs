{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, python3
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nickel";
    rev = "refs/tags/${version}";
    hash = "sha256-tb0nIBj/5nb0WbkceL7Rt1Rs0Qjy5/2leSOofF4zhTY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "topiary-core-0.3.0" = "sha256-2oVdtBcH1hF+p3PixBOljHXvGX2YCoRzA/vlBDvN7fE=";
      "topiary-queries-0.3.0" = "sha256-1leQLRohX0iDiOOO96ETM2L3yOElW8OwR5IcrsoxfOo=";
      "tree-sitter-nickel-0.1.0" = "sha256-HyHdameEgET5UXKMgw7EJvZsJxToc9Qz26XHvc5qmU0=";
    };
  };

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
