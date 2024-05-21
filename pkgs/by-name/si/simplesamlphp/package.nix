{
  php,
  fetchFromGitHub,
  lib,
}:
php.buildComposerProject (finalAttrs: {
  pname = "simplesamlphp";
  version = "1.19.7";

  src = fetchFromGitHub {
    owner = "simplesamlphp";
    repo = "simplesamlphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qmy9fuZq8MBqvYV6/u3Dg92pHHicuUhdNeB22u4hwwA=";
  };

  vendorHash = "sha256-FMFD0AXmD7Rq4d9+aNtGVk11YuOt40FWEqxvf+gBjmI=";

  meta = {
    description = "SimpleSAMLphp is an application written in native PHP that deals with authentication (SQL, .htpasswd, YubiKey, LDAP, PAPI, Radius).";
    homepage = "https://simplesamlphp.org";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ nhnn ];
  };
})
