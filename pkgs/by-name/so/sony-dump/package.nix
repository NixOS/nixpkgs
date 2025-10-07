{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:
stdenv.mkDerivation {
  pname = "sony-dump";
  version = "0-unstable-2019-11-3";

  src = fetchFromGitHub {
    owner = "munjeni";
    repo = "anyxperia_dumper";
    rev = "2171258c9df50aba139b4bd1aa93295cd14d2262";
    hash = "sha256-kdHMDIX+ryx63A5TJMsqEZ4W36edC+dQrJKTeh5RFHA=";
  };

  strictDeps = true;

  prePatch = ''
    tar -xzf ${zlib.src}
    mv ${zlib.name} zlib
  '';

  patches = [
    ./0001-Fix-makefile.patch
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 sony_dump -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/munjeni/anyxperia_dumper";
    description = "Tool to dump Sony Xperia boot images";
    # No license specified in the repository
    license = lib.licenses.free;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sony_dump";
  };
}
