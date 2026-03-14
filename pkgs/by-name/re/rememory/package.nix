{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rememory";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "eljojo";
    repo = "rememory";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MI2ono5hcEm+4oXq1HvSoNOZc8ALMV00dyo7JK80dnM=";
  };

  vendorHash = "sha256-/PnlHXAYlcR5jIKD5qwjKfv6/JldCXaorPSpW8GKXYo=";
  proxyVendor = true;

  nativeBuildInputs = with pkgs; [
    esbuild
  ];

  preBuild = ''
    make wasm
  '';

  postInstall = ''
    mkdir -p $out/share/man/man1
    $out/bin/rememory doc $out/share/man/man1
  '';

  subPackages = [ "cmd/rememory" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://eljojo.github.io/rememory";
    description = "Tool that encrypts files and splits the decryption key among trusted friends using Shamir's Secret Sharing";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rixxc ];
    platforms = lib.platforms.all;
  };
})
