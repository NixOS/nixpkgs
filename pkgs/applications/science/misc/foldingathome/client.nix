{ lib
, stdenv
, fetchFromGitHub
, scons
, openssl
}:
let
  version = "8.1.18";

  cbangSrc = fetchFromGitHub {
    owner = "cauldrondevelopmentllc";
    repo = "cbang";
    rev = "bastet-v${version}";
    hash = "sha256-G0rknVmZiyC4sRTOowFjf7EQ5peGf+HLPPcLWXXFlX4=";
  };

  fah-web-client-bastetSrc = fetchFromGitHub {
    owner = "foldingathome";
    repo = "fah-web-client-bastet";
    rev = "v${version}";
    hash = lib.fakeHash;
  };
in
stdenv.mkDerivation {
  pname = "fah-client";
  inherit version;

  src = fetchFromGitHub {
    owner = "FoldingAtHome";
    repo = "fah-client-bastet";
    rev = "v${version}";
    hash = "sha256-IgT/5NqCwN8N8OObjtASuT4IRb2EN4bdixxUdjiyddI=";
  };

  nativeBuildInputs = [ scons ];

  buildInputs = [ openssl ];

  postUnpack = ''
    export CBANG_HOME=$NIX_BUILD_TOP/cbang

    cp -r --no-preserve=mode ${cbangSrc} $CBANG_HOME
  '';

  preBuild = ''
    scons -C $CBANG_HOME
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/applications,share/feh-client}

    cp fah-client $out/bin/fah-client

    cp install/lin/fah-client.desktop $out/share/applications/
    cp -r images $out/share/feh-client/

    sed -e "s|Icon=.*|Icon=$out/share/feh-client/images/fahlogo.png|g" -i $out/share/applications/fah-client.desktop

    runHook postInstall
  '';

  meta = {
    description = "Folding@home client";
    homepage = "https://foldingathome.org/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
