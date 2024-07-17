{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "juruen";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-7pwCd9tey7w5B8UgsMLHegPqmmY1prLM+Sk9o42X9lY=";
  };

  vendorHash = "sha256-Id2RaiSxthyR6egDQz2zulbSZ4STRTaA3yQIr6Mx9kg=";

  doCheck = false;

  meta = with lib; {
    description = "Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/juruen/rmapi";
    changelog = "https://github.com/juruen/rmapi/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.nickhu ];
    mainProgram = "rmapi";
  };
}
