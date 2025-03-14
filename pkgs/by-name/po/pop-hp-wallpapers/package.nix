{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  imagemagick,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "pop-hp-wallpapers";
  version = "0-unstable-2022-04-01";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "hp-wallpapers";
    rev = "df86078846b0a2a4e3e64f584aaf2a21be47a7eb";
    forceFetchGit = true;
    fetchLFS = true;
    hash = "sha256-NGSvPC9GadqqqgGH9uDNAYuSwfagosmCAE6QmDtmdMw=";
  };

  nativeBuildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wallpapers for High-Performance System76 products";
    homepage = "https://pop.system76.com/";
    license = with lib.licenses; [ cc-by-sa-40 ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
}
