{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "swagger-cli";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "APIDevTools";
    repo = "swagger-cli";
    rev = "v${version}";
    sha256 = "sha256-WgzfSd57vRwa1HrSgNxD0F5ckczBkOaVmrEZ9tMAcRA=";
  };

  npmDepsHash = "sha256-go9eYGCZmbwRArHVTVa6mxL+kjvBcrLxKw2iVv0a5hY=";

  buildPhase = ''
    npm run bump
  '';

  postInstall = ''
    find $out/lib/node_modules -xtype l -delete
  '';

  meta = with lib; {
    description = "Swagger 2.0 and OpenAPI 3.0 command-line tool";
    homepage = "https://apitools.dev/swagger-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "swagger-cli";
  };
}
