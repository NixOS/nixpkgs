{
  lib,
  stdenv,
  fetchurl,
  gmp,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "nuxmv";
  version = "2.1.0";

  src = fetchurl {
    url = "https://nuxmv.fbk.eu/downloads/nuXmv-${version}-${
      if stdenv.hostPlatform.isDarwin then "macos-universal" else "linux64"
    }.tar.xz";
    sha256 =
      if stdenv.hostPlatform.isDarwin then
        "sha256-3AoXEPCunzbhYjjUCzXc9m+CPTVwE70udMCfbpucbdU="
      else
        "sha256-x9/sQ3SbyyMMhX7+gQmbldhouU79n4G8zr5UKjBqfIM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ gmp ];
  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin ./bin/nuXmv
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapProgram $out/bin/nuXmv --prefix DYLD_LIBRARY_PATH : ${gmp}/lib
  '';

  meta = {
    description = "Symbolic model checker for analysis of finite and infinite state systems";
    homepage = "https://nuxmv.fbk.eu/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
