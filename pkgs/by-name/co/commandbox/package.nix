{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  jdk11_headless,
}:

let
  version = "6.2.1";
in
stdenvNoCC.mkDerivation rec {
  pname = "commandbox";
  inherit version;

  src = fetchzip {
    url = "https://downloads.ortussolutions.com/ortussolutions/commandbox/${version}/commandbox-bin-${version}.zip";
    sha256 = "sha256-2+KvhdKhP2u1YqLN28AA2n4cdPQp4wgaOrpgqS7JFp8=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp box $out/bin/box
    chmod +x $out/bin/box

    # Ensure a JRE is in PATH; CommandBox requires Java 8+,
    # and docs recommend Java 11 with preliminary support for 17+. :contentReference[oaicite:2]{index=2}
    wrapProgram $out/bin/box \
      --prefix PATH : ${jdk11_headless}/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "CommandBox CFML CLI, package manager, and embedded CFML server";
    homepage = "https://www.ortussolutions.com/products/commandbox";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "box";
    maintainers = with lib.maintainers; [
      tombert
    ];
  };
}
