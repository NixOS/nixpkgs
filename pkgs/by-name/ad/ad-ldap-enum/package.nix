{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "ad-ldap-enum";
  version = "0-unstable-2023-02-10";
  src = fetchFromGitHub {
    owner = "CroweCybersecurity";
    repo = "ad-ldap-enum";
    rev = "60bc5bb111e2708d4bc2157f9ae3d5e0d06ece75";
    hash = "sha256-b77yWmZGyOSQSwnRhGqo501jO6XYd+qpx1pb+zkduVI=";
  };

  buildInputs = [
    (python3.withPackages (
      ps: with ps; [
        argcomplete
        ldap3
        openpyxl
      ]
    ))
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 ad-ldap-enum.py $out/bin/ad-ldap-enum

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchShebangs $out/bin/ad-ldap-enum

    runHook postFixup
  '';

  meta = {
    description = "LDAP based Active Directory user and group enumeration tool";
    homepage = "https://github.com/CroweCybersecurity/ad-ldap-enum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
    platforms = python3.meta.platforms;
    mainProgram = "ad-ldap-enum";
  };
}
