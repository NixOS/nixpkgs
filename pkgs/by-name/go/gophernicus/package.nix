{
  stdenv,
  buildPackages,
  lib,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  xinetd,
  systemdLibs,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  xinetdSupport ? lib.meta.availableOn stdenv.hostPlatform xinetd,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.1.1";
  pname = "gophernicus";

  src = fetchFromGitHub {
    owner = "gophernicus";
    repo = "gophernicus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P0LmdJsWWyOfIXzLoEcbxnHYIW8lRLoa4u/cVvrjZWg=";
  };

  env = lib.optionalAttrs (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
    HOSTCC = "${buildPackages.stdenv.cc}/bin/cc";
    CC = "${stdenv.cc.targetPrefix}cc";
  };

  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];
  configureFlags =
    let
      listeners =
        lib.optional stdenv.hostPlatform.isDarwin "mac"
        ++ lib.optional systemdSupport "systemd"
        ++ lib.optional xinetdSupport "xinetd";
    in
    [
      "--listener=${builtins.concatStringsSep "," listeners}"
      "--gopherroot=$(out)/srv/gopher"
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
    ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    coreutils
  ];

  postPatch = ''
    sed -e 's,init/$(PLIST).*,-D init/$(PLIST) $(DESTDIR)$(out)/Library/LaunchDaemons/$(PLIST),' \
        -e '/etc\/xinetd.d/d' \
        -e '/$(DESTDIR)$(ROOT)/d' \
        -e 's,-T init/$(NAME).xinetd.*,-D init/$(NAME).xinetd $(DESTDIR)$(out)$(XINETD)/$(NAME).xinetd,' \
        -e 's,$(INSTALL) -s,$(INSTALL) -s --strip-program=${stdenv.cc.targetPrefix}strip,' \
        -i Makefile.in
    sed -E -e 's,@(SYSCONF|SYSTEMD|DEFAULT)@,${placeholder "out"}/etc/\L\1,' \
        -i Makefile.in

    sed -e 's,/usr/local/sbin,${placeholder "out"}/bin,' \
        -e 's,-r/Library/GopherServer,-r/srv/gopher,' \
        -e '/-h@HOSTNAME@/d' \
        -i init/org.gophernicus.server.plist.in
    sed -e 's/-h @HOSTNAME@ //' \
        -i init/gophernicus.env.in
    sed -e 's,-r/var/gopher.*,-r/srv/gopher,' \
        -i init/gophernicus.xinetd.in
  '';

  postInstall = ''
    wrapProgram $out/sbin/gophernicus --run 'export HOSTNAME="$(${lib.getExe' coreutils "uname"} -n)"'
  '';

  meta = {
    description = "Small and secure Gopher server";
    homepage = "https://www.gophernicus.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ feyorsh ];
    mainProgram = "gophernicus";
  };
})
