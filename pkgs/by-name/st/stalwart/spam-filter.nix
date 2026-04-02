{
  lib,
  fetchFromGitHub,
  stdenv,
  stalwart,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spam-filter";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "spam-filter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2D/0mnkV4G/Gyr48rbMGTo6uTL7pe+AT+DNKqkBTIbA=";
  };

  buildPhase = ''
    bash ./build.sh
  '';

  installPhase = ''
    mkdir -p $out
    cp spam-filter.toml $out/
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Spam filter module for the Stalwart server";
    homepage = "https://github.com/stalwartlabs/spam-filter";
    changelog = "https://github.com/stalwartlabs/spam-filter/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    inherit (stalwart.meta) maintainers;
  };
})
