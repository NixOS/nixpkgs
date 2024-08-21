{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  perl,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cowsay";
  version = "3.8.2";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "cowsay-org";
    repo = "cowsay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IvodIoPrXI0D9pB95JPUBAIfxxnGDWl30P+WRf8VXIw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/cowsay \
      --suffix COWPATH : $out/share/cowsay/cows
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "cowsay --version";
    };
  };

  meta = {
    homepage = "https://cowsay.diamonds";
    description = "Program which generates ASCII pictures of a cow with a message";
    changelog = "https://github.com/cowsay-org/cowsay/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "cowsay";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    inherit (perl.meta) platforms;
  };
})
