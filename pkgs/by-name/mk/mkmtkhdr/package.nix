{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "mkmtkhdr";
  version = "0-unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "mkmtkhdr";
    rev = "be292c5295feb8158603c8575850208ea6218a78";
    hash = "sha256-eXC4OpjDCziahhhH73cOUkTsm1VFJE6wTtSk6RD5tqA=";
  };

  strictDeps = true;

  # Unstream has an install target, but installs mkmtkhdr as `$out/bin`
  # instead of `$out/bin/mkmtkhdr`
  installPhase = ''
    runHook preInstall
    install -Dm555 mkmtkhdr -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/mkmtkhdr";
    description = "Tool to write MTK headers for split zImages and ramdisks";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "mkmtkhdr";
  };
}
