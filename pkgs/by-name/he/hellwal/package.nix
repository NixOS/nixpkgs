{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hellwal";
  version = "1.0.7";
  src = fetchFromGitHub {
    owner = "danihek";
    repo = "hellwal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1oF+v3sEHf8DT7yLiWRYDppNx1LpiCNrm0IQ2IWIBLU=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -Dm755 hellwal -t $out/bin
    mkdir -p $out/share/docs/hellwal
    cp -r templates themes $out/share/docs/hellwal
  '';
  meta = {
    homepage = "https://github.com/danihek/hellwal";
    description = "Fast, extensible color palette generator";
    longDescription = ''
      Pywal-like color palette generator, but faster and in C.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ danihek ];
    mainProgram = "hellwal";
  };
})
