{
  lib,
  stdenv,
  fetchurl,
  nix-update-script,
  pam,
  xmlsec,
}:

let
  # TODO: Switch to OpenPAM once https://gitlab.com/oath-toolkit/oath-toolkit/-/issues/26 is addressed upstream
  securityDependency = if stdenv.hostPlatform.isDarwin then xmlsec else pam;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "oath-toolkit";
  version = "2.6.14";

  src = fetchurl {
    url = "mirror://savannah/oath-toolkit/oath-toolkit-${finalAttrs.version}.tar.gz";
    hash = "sha256-ix2jZXWfEkm+V6gq7G4Qf3tX3HfYE/ltwKr4FiTyiXE=";
  };

  buildInputs = [ securityDependency ];

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-pam" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Components for building one-time password authentication systems";
    homepage = "https://www.nongnu.org/oath-toolkit/";
    maintainers = with lib.maintainers; [ schnusch ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "oathtool";
  };
})
