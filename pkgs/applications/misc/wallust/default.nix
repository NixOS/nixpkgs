{lib, fetchgit, rustPlatform}:

let
  repoUrl = "https://codeberg.org/explosion-mental/wallust";
in rustPlatform.buildRustPackage rec {
  pname = "wallust";
  version = "2.5.0";

  src = fetchgit {
    url = "${repoUrl}.git";
    rev = version;
    sha256 = "sha256-np03F4XxGFjWfxCKUUIm7Xlp1y9yjzkeb7F2I7dYttA=";
  };

  cargoSha256 = "sha256-yq51LQB53VKjMoNM3f/JzifEHSA69Jso2QYRsaplQfk=";

  meta = with lib; {
    description = "A better pywal";
    homepage = repoUrl;
    license = licenses.mit;
    maintainers = with maintainers; [onemoresuza];
    downloadPage = "${repoUrl}/releases/tag/${version}";
    platforms = platforms.unix;
    mainProgram = "wallust";
  };
}
