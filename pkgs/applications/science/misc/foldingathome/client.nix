{ lib
, buildFHSEnv
, fetchFromGitHub
, ocl-icd
, openssl
, scons
, stdenv
, extraPkgs ? [ ]
}:
let
  version = "8.3.1";

  cbangSrc = fetchFromGitHub {
    owner = "cauldrondevelopmentllc";
    repo = "cbang";
    rev = "bastet-v${version}";
    hash = "sha256-cuyfJG5aDJ6e2SllxwKTViG0j8FWHvjcTaaBBtkgEdU=";
  };

  fah-client = stdenv.mkDerivation {
    pname = "fah-client";
    inherit version;

    src = fetchFromGitHub {
      owner = "FoldingAtHome";
      repo = "fah-client-bastet";
      rev = "v${version}";
      hash = "sha256-Ztc2im4Xmk8f6GotGRgA5zDkcyQFnodUvroJVl+ApT4=";
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

      mkdir -p $out/{bin,share/applications}

      cp fah-client $out/bin/fah-client

      cp install/lin/fah-client.desktop.in $out/share/applications/fah-client.desktop
      sed \
        -e "s|Icon=.*|Icon=$out/share/feh-client/images/fahlogo.png|g" \
        -e "s|%(PACKAGE_URL)s|https://github.com/FoldingAtHome/fah-client-bastet|g" \
        -i $out/share/applications/fah-client.desktop

      runHook postInstall
    '';

  };
in
buildFHSEnv {
  name = fah-client.name;

  targetPkgs = _: [ fah-client ocl-icd ] ++ extraPkgs;

  runScript = "/bin/fah-client";

  extraInstallCommands = ''
    mv $out/bin/$name $out/bin/fah-client
  '';

  meta = {
    description = "Folding@home client";
    homepage = "https://foldingathome.org/";
    license = lib.licenses.gpl3;
    mainProgram = "fah-client";
    maintainers = [ lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
