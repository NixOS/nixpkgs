{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "legit";
  version = "0.2.2";

  src = fetchFromGitHub {
    repo = "legit";
    owner = "icyphox";
    rev = "v${version}";
    hash = "sha256-TBq1ILBhojMIxnLj108L0zLmFsZD/ET9w5cSbqk8+XM=";
  };

  vendorHash = "sha256-IeWgmUNkBU3W6ayfRkzMO/0XHNqm5zy5lLUNePzv+ug=";

  postInstall = ''
    mkdir -p $out/lib/legit/templates
    mkdir -p $out/lib/legit/static

    cp -r $src/templates/* $out/lib/legit/templates
    cp -r $src/static/* $out/lib/legit/static
  '';

  meta = {
    description = "Web frontend for git";
    homepage = "https://github.com/icyphox/legit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
    mainProgram = "legit";
  };
}
