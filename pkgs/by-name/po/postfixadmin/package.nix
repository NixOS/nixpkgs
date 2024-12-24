{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "postfixadmin";
  version = "3.3.15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-dKdJS9WQ/pPYITP53/Aynls8ZgVF7tAqL9gQEw+u8TM=";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/postfixadmin/config.local.php $out/
    ln -sf /var/cache/postfixadmin/templates_c $out/
  '';

  passthru.tests = { inherit (nixosTests) postfixadmin; };

  meta = {
    description = "Web based virtual user administration interface for Postfix mail servers";
    homepage = "https://postfixadmin.sourceforge.io/";
    maintainers = with lib.maintainers; [ globin ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
