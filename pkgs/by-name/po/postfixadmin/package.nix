{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nixosTests,

  configLocalPath ? "/etc/postfixadmin/config.local.php",
  templatesCachePath ? "/var/cache/postfixadmin/templates_c",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "postfixadmin";
  version = "3.3.14";

  src = fetchFromGitHub {
    owner = "postfixadmin";
    repo = "postfixadmin";
    rev = "refs/tags/postfixadmin-${finalAttrs.version}";
    sha256 = "sha256-T7KRD0ihtWcvJB6pZxXThFHerL5AGd8+mCg8UIXPZ4g=";
  };

  patches = [
    # Fix https://github.com/postfixadmin/postfixadmin/issues/872
    (fetchpatch2 {
      url = "https://github.com/postfixadmin/postfixadmin/commit/8ec9140673afd9996a3f81cca600ea0e5bd31cf8.patch";
      hash = "sha256-OLkWeVL5ryuIONb/RF6Uv7UQDfVsbEkrx50rMDungGI=";
    })
  ];

  strictDeps = true;

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
