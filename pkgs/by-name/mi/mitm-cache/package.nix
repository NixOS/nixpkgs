{
  lib,
  fetchFromGitHub,
  callPackage,
  rustPlatform,
  replaceVars,
  openssl,
  python3Packages,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitm-cache";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "chayleaf";
    repo = "mitm-cache";
    rev = "v${version}";
    hash = "sha256-eY8mgmQB8wXQ7YJbLvdjXEEgGD+/RDywjvehJYf7ckE=";
  };

  cargoHash = "sha256-DTPlPCumkVI2naYoNdO8T3pQNSawBA0FZ9LxVpqKqN0=";

  setupHook = replaceVars ./setup-hook.sh {
    inherit openssl;
    ephemeral_port_reserve = python3Packages.ephemeral-port-reserve;
  };

  passthru.fetch = callPackage ./fetch.nix { };

  meta = with lib; {
    description = "MITM caching proxy for use in nixpkgs";
    homepage = "https://github.com/chayleaf/mitm-cache#readme";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
    mainProgram = "mitm-cache";
  };
}
