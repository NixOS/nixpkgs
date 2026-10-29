{
  lib,
  stdenv,
  fetchFromGitHub,
  xcbuild,
}:

stdenv.mkDerivation rec {
  pname = "choose-gui";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "chipsenkbeil";
    repo = "choose";
    rev = version;
    hash = "sha256-ewXZpP3XmOuV/MA3fK4BwZnNb2jkE727Sse6oAd4HJk=";
  };

  nativeBuildInputs = [ xcbuild ];

  buildPhase = ''
    runHook preBuild
    xcodebuild -configuration Release SYMROOT="./output" HOME="$(mktemp -d)" build
    cp ./output/Release/choose choose
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp choose $out/bin/choose
    chmod +x $out/bin/choose
    runHook postInstall
  '';

  meta = {
    description = "Fuzzy matcher for OS X that uses both std{in,out} and a native GUI";
    homepage = "https://github.com/chipsenkbeil/choose";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    changelog = "https://github.com/chipsenkbeil/choose/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      heywoodlh
      niksingh710
    ];
    mainProgram = "choose";
  };
}
