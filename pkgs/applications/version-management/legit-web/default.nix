{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "legit";
  version = "0.2.1";

  src = fetchFromGitHub {
    repo = "legit";
    owner = "icyphox";
    rev = "v${version}";
    hash = "sha256-Y0lfbe4xBCj80z07mLFIiX+shvntYAHiW2Uw7h94jrE=";
  };

  vendorHash = "sha256-RAUSYCtP4rcJ2zIBXfPAEZWD1VSfr3d4MrmUMiPpjK8=";

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
