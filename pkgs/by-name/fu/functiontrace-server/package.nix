{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "functiontrace-server";
  version = "0.8.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xTNNAYhxyL5/Sip+nZJleWOjTYs2MH3QM7pzLYk/6Gs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zwarLDKaI4TMCId8+3wVtioOMw2F8Z7Rnl0bKbQVndQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Server for FunctionTrace, a graphical Python profiler";
    homepage = "https://functiontrace.com";
    license = with licenses; [ prosperity30 ];
    maintainers = with maintainers; [ tehmatt ];
  };
}
