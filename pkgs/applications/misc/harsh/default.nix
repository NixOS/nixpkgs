{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "harsh";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XkOdW6ewout69A1ovth1iQR36nRtkdsbDI9CWibSHXs=";
  };

  vendorHash = "sha256-4Sa8/mVD7t4uR8Wq4n+fvot7LZfraphFobrG6rteQeI=";

  meta = with lib; {
    description = "CLI habit tracking for geeks";
    homepage = "https://github.com/wakatara/harsh";
    changelog = "https://github.com/wakatara/harsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "harsh";
  };
}
