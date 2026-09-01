{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gokart";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "gokart";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-G1IjlJ/rmviFWy6RFfLtP+bhfYcDuB97leimU39YCoQ=";
  };

  vendorHash = "sha256-lgKYVgJlmUJ/msdIqG7EKAZuISie1lG7+VeCF/rcSlE=";

  # Would need files to scan which are not shipped by the project
  doCheck = false;

  meta = {
    description = "Static analysis tool for securing Go code";
    mainProgram = "gokart";
    homepage = "https://github.com/praetorian-inc/gokart";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
