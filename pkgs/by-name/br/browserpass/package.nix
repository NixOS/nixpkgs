{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  gnupg,
  makeWrapper,
  autoPatchelfHook,
  testers,
  browserpass,
}:

buildGoModule (finalAttrs: {
  pname = "browserpass";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-native";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-zsp5OrzTNLfYkAdg5Ru5FMXMVSPCLAUBAF6QLM+qU/c=";
  };

  patches = [
    # The 3.1.2 tag still imports its own packages through the old module
    # path, so it builds the pinned 3.1.0 sources and reports that version.
    (fetchpatch {
      name = "use-v3-module-path-for-local-imports.patch";
      url = "https://github.com/browserpass/browserpass-native/commit/da47c6a817ed3d6e7302979a6d3088446e4c6e1e.patch";
      hash = "sha256-TzrzQ6ViKf539HTgYu7DFDOVfjU72+2W0h7VRxjabuE=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  vendorHash = "sha256-Fy1AMCjEVE8+niwmLYVII63qSJLavQRgcK8RXaAkF+s=";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postPatch = ''
    # Because this Makefile will be installed to be used by the user, patch
    # variables to be valid by default
    substituteInPlace Makefile \
      --replace "PREFIX ?= /usr" ""
    sed -i -e 's/SED =.*/SED = sed/' Makefile
    sed -i -e 's/INSTALL =.*/INSTALL = install/' Makefile
  '';

  env.DESTDIR = placeholder "out";

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

  meta = {
    description = "Browserpass native client app";
    mainProgram = "browserpass";
    homepage = "https://github.com/browserpass/browserpass-native";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
})
