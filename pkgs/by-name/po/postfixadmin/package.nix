{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,

  configLocalPath ? "/etc/postfixadmin/config.local.php",
  templatesCachePath ? "/var/cache/postfixadmin/templates_c",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "postfixadmin";
  version = "3.3.15";

  src = fetchFromGitHub {
    owner = "postfixadmin";
    repo = "postfixadmin";
    tag = "postfixadmin-${finalAttrs.version}";
    sha256 = "sha256-dKdJS9WQ/pPYITP53/Aynls8ZgVF7tAqL9gQEw+u8TM=";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf '${configLocalPath}' $out/config.local.php
    ln -sf '${templatesCachePath}' $out/templates_c
  '';

  passthru.tests = { inherit (nixosTests) postfixadmin; };

  meta = with lib; {
    description = "Web based virtual user administration interface for Postfix mail servers";
    homepage = "https://postfixadmin.github.io/postfixadmin/";
    maintainers = with maintainers; [ globin ];
    license = licenses.gpl2Plus;
    platforms = lib.subtractLists platforms.darwin platforms.unix; # There is no /var/cache/ on MacOS
  };
})
