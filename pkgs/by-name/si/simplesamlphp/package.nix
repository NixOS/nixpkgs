{
  php,
  fetchFromGitHub,
  lib,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "simplesamlphp";
  version = "1.19.7";

  src = fetchFromGitHub {
    owner = "simplesamlphp";
    repo = "simplesamlphp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qmy9fuZq8MBqvYV6/u3Dg92pHHicuUhdNeB22u4hwwA=";
  };

  vendorHash = "sha256-kFRvOxSfqlM+xzFFlEm9YrbQDOvC4AA0BtztFQ1xxDU=";

  meta = {
    description = "Application written in native PHP that deals with authentication (SQL, .htpasswd, YubiKey, LDAP, PAPI, Radius)";
    homepage = "https://simplesamlphp.org";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ nhnn ];
  };
})
