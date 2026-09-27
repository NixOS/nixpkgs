{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "oauth2c";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "SecureAuthCorp";
    repo = "oauth2c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IYZYdx8oe5L7zB6HwtSOWXe+JveMWiORLN+j8h3pQug=";
  };

  vendorHash = "sha256-H5iRmX6Wcef7IVOY5NQ+jX9zyJCzZ34Haf7cIflK5GY=";

  doCheck = false; # tests want to talk to oauth2c.us.authz.cloudentity.io

  meta = {
    homepage = "https://github.com/SecureAuthCorp/oauth2c";
    description = "User-friendly OAuth2 CLI";
    mainProgram = "oauth2c";
    longDescription = ''
      oauth2c is a command-line tool for interacting with OAuth 2.0
      authorization servers. Its goal is to make it easy to fetch access tokens
      using any grant type or client authentication method. It is compliant with
      almost all basic and advanced OAuth 2.0, OIDC, OIDF FAPI and JWT profiles.
    '';
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
