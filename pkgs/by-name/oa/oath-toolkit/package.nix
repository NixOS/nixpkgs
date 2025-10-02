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
  version = "2.6.13";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-W12C6aRFUgbST8vX7li/THk5ii5nmX2AvUWuknWGsYs=";
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
