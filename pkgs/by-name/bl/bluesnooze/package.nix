{
  fetchurl,
  lib,
  stdenv,
  unzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bluesnooze";
  version = "1.2";
  src = fetchurl {
    url = "https://github.com/odlp/bluesnooze/releases/download/v${finalAttrs.version}/Bluesnooze.zip";
    hash = "sha256-B1qLfPj2bU9AAsYqGYWl0/sEPj3wnn/UBeiM4kqW/rA=";
  };

  # Needed to avoid the binary becoming corrupted and mac refusing to open it. I
  # don't know why.
  dontFixup = true;

  # "unpack" phase does the unzipping automatically
  nativeBuildInputs = [ unzip ];
  sourceRoot = "."; # squash "unpacker produced multiple directories" error

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r Bluesnooze.app $out/Applications/

    runHook postInstall
  '';

  meta = {
    description = "Prevents your sleeping Mac from connecting to Bluetooth accessories";
    homepage = "https://github.com/odlp/bluesnooze";
    changelog = "https://github.com/odlp/bluesnooze/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ craigf ];
    platforms = lib.platforms.darwin;
  };
})
