{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  gnused,
  systemdMinimal,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
  xinetd,
  xinetdSupport ? lib.meta.availableOn stdenv.hostPlatform xinetd,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gophernicus";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gophernicus";
    repo = "gophernicus";
    tag = finalAttrs.version;
    hash = "sha256-pweiUiMmLXiyF9NMxvcWfJPH6JiGRlpT4chJiRGh9vg=";
  };

  postPatch = ''
    substituteInPlace README.md \
      --replace-warn 'DEVEL' '${finalAttrs.version}'

    substituteInPlace src/gophernicus.h \
      --replace-fail 'SAFE_PATH    "/usr/bin:/bin"' 'SAFE_PATH    "/usr/bin:/bin:/run/gophernicus/bin"'

    substituteInPlace init/gophernicus.xinetd.in \
      --replace-fail ' -h@HOSTNAME@' '''

    substituteInPlace init/gophernicus.env.in \
      --replace-fail '-h @HOSTNAME@ ' '''

    substituteInPlace init/org.gophernicus.server.plist.in \
      --replace-fail '${"\t\t"}<string>-h@HOSTNAME@</string>${"\n"}' ''' \
      --replace-fail '/usr/local/sbin' '${placeholder "out"}/sbin'

    substituteInPlace init/gophernicus@.service.in \
      --replace-fail 'User=nobody' '''

    substituteInPlace Makefile.in \
      --replace-fail \
        '$(INSTALL) -s' \
        '$(INSTALL) -s --strip-program=${stdenv.cc.targetPrefix}strip' \
      --replace-fail \
        '$(INSTALL) -m 644 init/$(PLIST) $(DESTDIR)$(LAUNCHD)' \
        '$(INSTALL) -Dm 644 -t $(DESTDIR)$(LAUNCHD) init/$(PLIST)'

    sed -E -i '/^\s+(chown|chmod)/d' Makefile.in
  '';

  configurePlatforms = [ ];
  dontAddStaticConfigureFlags = true;
  configureFlags = [
    "--prefix=/"
    "--gopherroot=/share/gophernicus/gopher"
    "--os=${
      if stdenv.hostPlatform.isDarwin then
        "mac"
      else if stdenv.hostPlatform.isLinux then
        "linux"
      else if stdenv.hostPlatform.isBSD then
        "freebsd"
      else
        "autodetected"
    }"
  ]
  ++ lib.optionals systemdSupport [
    "--listener=systemd"
  ]
  ++ lib.optionals xinetdSupport [
    "--listener=xinetd"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--listener=mac"
  ];

  env = lib.optionalAttrs (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
    HOSTCC = "${buildPackages.stdenv.cc}/bin/cc";
    CC = "${stdenv.cc.targetPrefix}cc";
  };

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  installTargets = [
    "install"
  ]
  ++ lib.optionals systemdSupport [
    "install-systemd"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern full-featured (and hopefully) secure gopher daemon";
    homepage = "https://gophernicus.org/";
    changelog = "https://github.com/gophernicus/gophernicus/blob/${finalAttrs.src.tag}/changelog";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.h7x4 ];
    mainProgram = "gophernicus";
  };
})
