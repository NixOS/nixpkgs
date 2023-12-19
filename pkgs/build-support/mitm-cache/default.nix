{ lib
, fetchFromGitHub
, callPackage
, rustPlatform
, substituteAll
, openssl
}:

rustPlatform.buildRustPackage {
  pname = "mitm-cache";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "chayleaf";
    repo = "mitm-cache";
    rev = "6d43c4875f29c1abe21e665f15734ac8cd230c49";
    hash = "sha256-Yrgu+ILaIuoYlM3P/+Osn2nDxr9klBzQF/098CYiGEg=";
  };

  cargoHash = "sha256-/H9Ls50fLnYb+S8dFKXPtDBDvrA305ezYZTQsAgGq3k=";

  setupHook = substituteAll {
    src = ./setup-hook.sh;
    inherit openssl;
  };

  passthru.fetch = callPackage ./fetch.nix { };

  meta = with lib; {
    description = "A MITM caching proxy for use in nixpkgs";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
  };
}
