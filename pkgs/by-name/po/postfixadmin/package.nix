{
  fetchFromGitHub,
  stdenv,
  lib,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "postfixadmin";
  version = "3.3.16";

  src = fetchFromGitHub {
    owner = "postfixadmin";
    repo = "postfixadmin";
    tag = "postfixadmin-${version}";
    hash = "sha256-sSn5XHxnpP2Axv9BD9IvzSmu8MthcylEPk1kU51p/3k=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out/
    ln -sf /etc/postfixadmin/config.local.php $out/
    ln -sf /var/cache/postfixadmin/templates_c $out/

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) postfixadmin; };

  meta = {
    changelog = "https://github.com/postfixadmin/postfixadmin/releases/tag/${src.tag}";
    description = "Web based virtual user administration interface for Postfix mail servers";
    homepage = "https://postfixadmin.sourceforge.io/";
    maintainers = with lib.maintainers; [ globin ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
