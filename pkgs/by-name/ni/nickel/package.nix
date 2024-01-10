{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, python3
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nickel";
    rev = "refs/tags/${version}";
    hash = "sha256-MBonps3yFEpw9l3EAJ6BXNNjY2fUGzWCP+7h0M8LEAY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "topiary-0.2.3" = "sha256-EgDFjJeGJb36je/be7DXvzvpBYDUaupOiQxtL7bN/+Q=";
      "tree-sitter-bash-0.20.4" = "sha256-VP7rJfE/k8KV1XN1w5f0YKjCnDMYU1go/up0zj1mabM=";
      "tree-sitter-facade-0.9.3" = "sha256-M/npshnHJkU70pP3I4WMXp3onlCSWM5mMIqXP45zcUs=";
      "tree-sitter-nickel-0.0.1" = "sha256-aYsEx1Y5oDEqSPCUbf1G3J5Y45ULT9OkD+fn6stzrOU=";
      "tree-sitter-query-0.1.0" = "sha256-5N7FT0HTK3xzzhAlk3wBOB9xlEpKSNIfakgFnsxEi18=";
      "tree-sitter-json-0.20.1" = "sha256-Msnct7JzPBIR9+PIBZCJTRdVMUzhaDTKkl3JaDUKAgo=";
      "tree-sitter-ocaml-0.20.4" = "sha256-j3Hv2qOMxeBNOW+WIgIYzG3zMIFWPQpoHe94b2rT+A8=";
      "tree-sitter-ocamllex-0.20.2" = "sha256-YhmEE7I7UF83qMuldHqc/fD/no/7YuZd6CaAIaZ1now=";
      "tree-sitter-toml-0.5.1" = "sha256-5nLNBxFeOGE+gzbwpcrTVnuL1jLUA0ZLBVw2QrOLsDQ=";
      "tree-sitter-rust-0.20.4" = "sha256-ht0l1a3esvBbVHNbUosItmqxwL7mDp+QyhIU6XTUiEk=";
      "web-tree-sitter-sys-1.3.0" = "sha256-9rKB0rt0y9TD/HLRoB9LjEP9nO4kSWR9ylbbOXo2+2M=";

    };
  };

  cargoBuildFlags = [ "-p nickel-lang-cli" "-p nickel-lang-lsp" ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    # Work around https://github.com/NixOS/nixpkgs/issues/166205.
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

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
  };
}
