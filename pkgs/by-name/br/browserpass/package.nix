{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gnupg,
  makeWrapper,
  autoPatchelfHook,
  testers,
  browserpass,
}:

buildGoModule rec {
  pname = "browserpass";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-native";
    rev = version;
    sha256 = "sha256-UZzOPRRiCUIG7uSSp9AEPMDN/+4cgyK47RhrI8oUx8U=";
  };

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  vendorHash = "sha256-CjuH4ANP2bJDeA+o+1j+obbtk5/NVLet/OFS3Rms4r0=";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postPatch = ''
    # Because this Makefile will be installed to be used by the user, patch
    # variables to be valid by default
    substituteInPlace Makefile \
      --replace "PREFIX ?= /usr" ""
    sed -i -e 's/SED =.*/SED = sed/' Makefile
    sed -i -e 's/INSTALL =.*/INSTALL = install/' Makefile
  '';

  DESTDIR = placeholder "out";

  postConfigure = ''
    make configure
  '';

  buildPhase = ''
    make browserpass
  '';

  checkTarget = "test";

  installPhase = ''
    make install

    wrapProgram $out/bin/browserpass \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}

    # This path is used by our firefox wrapper for finding native messaging hosts
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    # Copy ff manifests rather than linking to allow link-farming to work recursively in dependants
    cp $out/lib/browserpass/hosts/firefox/*.json $out/lib/mozilla/native-messaging-hosts/
  '';

  passthru.tests.version = testers.testVersion {
    package = browserpass;
    command = "browserpass --version";
  };

  meta = with lib; {
    description = "Browserpass native client app";
    mainProgram = "browserpass";
    homepage = "https://github.com/browserpass/browserpass-native";
    license = licenses.isc;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
