{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  libgit2,
  git,
  pkg-config,
  zlib,
}:

rustPlatform.buildRustPackage {
  pname = "git-agecrypt";
  version = "unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "git-agecrypt";
    rev = "126be86c515466c5878a60561f754a9ab4af6ee8";
    hash = "sha256-cmnBW/691mmLHq8tWpD3+zwCf7Wph5fcVdSxQGxqd1k=";
  };

  cargoHash = "sha256-FmlJeWMIIyTsg3TTLUia14et+aTgFCTkOr1J5dp0SGY=";

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    libgit2
    zlib
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "Alternative to git-crypt using age instead of GPG.";
    homepage = "https://github.com/vlaci/git-agecrypt";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kuznetsss ];
    mainProgram = "git-agecrypt";
  };
}
