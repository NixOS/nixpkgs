{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unzip,
}:

buildGoModule rec {
  pname = "goresym";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "goresym";
    rev = "v${version}";
    hash = "sha256-tt13vHe6wE27kv+1HVXytY1hKmOt6rWJaMBgLRCvO2E=";
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

  meta = with lib; {
    description = "Go symbol recovery tool";
    mainProgram = "GoReSym";
    homepage = "https://github.com/mandiant/GoReSym";
    changelog = "https://github.com/mandiant/GoReSym/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pyrox0 ];
  };
}
