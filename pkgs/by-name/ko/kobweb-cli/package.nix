{
  lib,
  stdenv,
  makeWrapper,
  jdk17,
}:
stdenv.mkDerivation rec {
  pname = "kobweb-cli";
  version = "0.9.21";

  src = builtins.fetchurl {
    url = "https://github.com/varabyte/kobweb-cli/releases/download/v${version}/kobweb-${version}.tar";
    sha256 = "sha256:0wy7jqzafr9w2d8l52ykqr5ify6xj029j7z3wv38sqc6zr7fvskp";
  };

  unpackPhase = ''
    tar -xf $src "kobweb-${version}"
    mv "kobweb-${version}" source
  '';

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    cp -r source/* $out/
    chmod +x $out/bin/kobweb
    wrapProgram $out/bin/kobweb \
      --prefix PATH : ${jdk17}/bin
  '';

  meta = {
    homepage = "https://github.com/varabyte/kobweb-cli";
    changelog = "https://github.com/varabyte/kobweb-cli/releases/tag/v${version}";
    description = "The CLI binary that drives the interactive Kobweb experience.";
    mainProgram = "kobweb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philippschuetz
    ];
  };
}
