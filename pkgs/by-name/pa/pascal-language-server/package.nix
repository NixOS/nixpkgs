{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus,
  writableTmpDirAsHomeHook,
  makeWrapper,
  bash,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pascal-language-server";
  version = "13-08-2026";

  src = fetchFromGitHub {
    owner = "genericptr";
    repo = "pascal-language-server";
    rev = "818f6330b721ed5c89d1fd8f66186f11b7b242b4";
    hash = "sha256-2ZtT8tnD8to9swB4djXXsv/uIxzDq6y9xZ4+Hy0mV0s=";
  };

  __structuredAttrs = true;

  strictDeps = true;
  nativeBuildInputs = [
    fpc
    lazarus
    writableTmpDirAsHomeHook # lazarus tries to create files in $HOME/.lazarus
    makeWrapper
    bash
  ];

  buildPhase = ''
    lazbuild --lazarusdir="${lazarus}/share/lazarus" \
      src/protocol/lspprotocol.lpk \
      src/serverprotocol/lspserver.lpk \
      src/standard/pasls.lpi
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/opt"

    cp "src/standard/pasls" "$out/opt/pasls"
    makeWrapper "$out/opt/pasls" "$out/bin/pasls" \
      --prefix FPCDIR : ${lazarus}/share/fpcsrc \
      --prefix PP : ${fpc}/bin/fpc \
      --prefix LAZARUSDIR : ${lazarus}/share/lazarus
  '';

  meta = {
    description = "An LSP server implementation for Pascal variants that are supported by Free Pascal, including Object Pascal.";
    homepage = "https://github.com/genericptr/pascal-language-server";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ megapixel-code ];
    mainProgram = "pasls";
    platforms = lib.platforms.unix;
  };
})
