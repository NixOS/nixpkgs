{ lib
, buildFHSEnv
, fetchFromGitHub
, ocl-icd
, openssl
, re2
, libevent
, git
, zlib
, expat
, scons
, stdenv
, extraPkgs ? [ ]
}:
let
  version = "8.3.7";

  cbangSrc = fetchFromGitHub {
    owner = "cauldrondevelopmentllc";
    repo = "cbang";
    rev = "bastet-v${version}";
    sha256 = "sha256-acAImItdkgo6PBFL6Vu/caIdcnvp/3VEW2lgVDgKy9g=";
  };

  fah-client = stdenv.mkDerivation {
    pname = "fah-client";
    inherit version;

    src = fetchFromGitHub {
      owner = "FoldingAtHome";
      repo = "fah-client-bastet";
      rev = "v${version}";
      sha256 = "sha256-d+LY/R4TAko+2e2W76KEBQ8fXj0hzzmBOm+c4tksXMA=";
    };

    nativeBuildInputs = [ scons re2 libevent git ];

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

  targetPkgs = _: [ fah-client ocl-icd zlib expat ] ++ extraPkgs;

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
