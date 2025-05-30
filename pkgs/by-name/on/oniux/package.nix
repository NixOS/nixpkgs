{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rtQUHTDPQXL4gT8/Nl0hV/F06ybPIfemibCzH3mFHaY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-79KNytAXxuYi9VBmkkOJg2ugjjoKJ/BPBqWa7Z72HGI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.torproject.org/tpo/core/oniux";
    description = "Isolate Applications over Tor using Linux Namespaces";
    maintainers = with lib.maintainers; [ tnias ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "oniux";
  };
})
