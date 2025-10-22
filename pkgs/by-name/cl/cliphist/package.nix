{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "cliphist";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "cliphist";
    tag = "v${version}";
    hash = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
  };

  vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";

  postInstall = ''
    cp ${src}/contrib/* $out/bin/
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "cliphist";
  };
}
