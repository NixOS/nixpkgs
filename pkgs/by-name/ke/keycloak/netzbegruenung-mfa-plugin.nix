{
  stdenv,
  maven,
  lib,
  fetchFromGitHub,
  pname,
  module,
  description,
}:
maven.buildMavenPackage (finalAttrs: {
  inherit pname;
  version = "26.6.5";

  src = fetchFromGitHub {
    owner = "netzbegruenung";
    repo = "keycloak-mfa-plugins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SR0jnnS7zz0c9hyXkNw/p+fT2lfUTzHWDfpIRskSneQ=";
  };

  mvnHash =
    let
      mvnHashes = {
        "aarch64-darwin" = "sha256-wBflqfJlTZkSdLnM6BLh6y05maVRAAyXXwrHDarYYN0=";
        "aarch64-linux" = "sha256-WOct8X9N9ToH0pQ7Ql/85pLVHNns1e5Jo+Oi0K3UKKs=";
        "x86_64-linux" = "sha256-CTbdSww95kCUgrHmB5fQpR0pp+hvlM66/alm6VjiD1k=";
      };
    in
    mvnHashes.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 ${module}/target/netzbegruenung.${module}-v${finalAttrs.version}.jar $out/${pname}.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/netzbegruenung/keycloak-mfa-plugins";
    changelog = "https://github.com/netzbegruenung/keycloak-mfa-plugins/releases/tag/v${finalAttrs.version}";
    inherit description;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anish ];
  };
})
