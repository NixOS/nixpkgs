{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "parlance";
  version = "0-unstable-2025-11-09";

  __structuredAttrs = true;
  # Tests bind servers to localhost
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "buyukakyuz";
    repo = "parlance";
    rev = "e663c3bec86faf9b2eb0a1df30e287797571776f";
    hash = "sha256-4OG2MZkLoQua4ehiEW3whOIBWfjtxRYOx4QwXgsmEhE=";
  };

  cargoHash = "sha256-P4VDLSbshdeWlYCoJxLzlmpUYP9cq3EXc3KYesTvHLs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Peer-to-peer messaging with LAN multicast or bootstrap server discovery";
    homepage = "https://github.com/buyukakyuz/parlance";
    license = lib.licenses.unfree; # https://github.com/buyukakyuz/parlance/issues/1
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "parlance";
  };
}
