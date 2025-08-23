{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unzip,
}:

buildGoModule rec {
  pname = "goresym";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "goresym";
    rev = "v${version}";
    hash = "sha256-BgnT0qYPH8kMI837hnUK5zGhboGgRU7VeU5dKNcrj8g=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-pjkBrHhIqLmSzwi1dKS5+aJrrAAIzNATOt3LgLsMtx0=";

  nativeCheckInputs = [ unzip ];

  preCheck = ''
    cd test
    unzip weirdbins.zip
    cd ..
  '';

  doCheck = true;

  meta = {
    description = "Go symbol recovery tool";
    mainProgram = "GoReSym";
    homepage = "https://github.com/mandiant/GoReSym";
    changelog = "https://github.com/mandiant/GoReSym/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
