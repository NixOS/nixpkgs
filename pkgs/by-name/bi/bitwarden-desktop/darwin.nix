{
  pname,
  meta,
  fetchurl,
  undmg,
  stdenv,
  ...
}:

let
  version = "2024.3.2";
in
stdenv.mkDerivation {
  inherit pname version;

  src = (
    fetchurl {
      url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-universal.dmg";
      sha256 = "sha256-SqChHwaOR4mJXeQPXsJqFpPDrAhdEjrBpT8PQaTK6B8=";
    }
  );

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
}
