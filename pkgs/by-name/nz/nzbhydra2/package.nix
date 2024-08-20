{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  openjdk17,
  python3,
  unzip,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "nzbhydra2";
  version = "7.5.0";

  src = fetchzip {
    url = "https://github.com/theotherp/${pname}/releases/download/v${version}/${pname}-${version}-generic.zip";
    hash = "sha256-jnClKsWSdRWCxNFO9RSnjdoDjOmtv9CrOL9KyaZ8PTc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    openjdk17
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    install -d -m 755 "$out/lib/${pname}"
    cp -dpr --no-preserve=ownership "lib" "readme.md" "$out/lib/nzbhydra2"
    install -D -m 755 "nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${python3}/bin/python $out/bin/nzbhydra2 \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      --prefix PATH ":" ${openjdk17}/bin

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) nzbhydra2;
  };

  meta = {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.linux;
    mainProgram = "nzbhydra2";
  };
}
