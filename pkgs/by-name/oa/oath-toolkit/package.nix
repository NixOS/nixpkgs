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
stdenv.mkDerivation rec {
  pname = "oath-toolkit";
  version = "2.6.12";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-yv33ObHsSydkQcau2uZBFDS72HAHH2YVS5CcxuLZ6Lo=";
  };

  buildInputs = [ securityDependency ];

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-pam" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Components for building one-time password authentication systems";
    homepage = "https://www.nongnu.org/oath-toolkit/";
    maintainers = with maintainers; [ schnusch ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "oathtool";
  };
}
