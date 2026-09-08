{
  stdenv,
  lib,
  fetchzip,
  libident,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "efingerd";
  version = "1.6.5";
  src = fetchzip {
    url = "https://kassiopeia.juls.savba.sk/~garabik/software/${pname}/${pname}_${version}.tar.gz";
    curlOpts = "-k";
    hash = "sha256-mtv6dZOHYF8EyM75R57ywS8bdkY14I1Hs1C7aP67yas=";
  };
  nativeBuildInputs = [
    libident
    versionCheckHook
  ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace '/usr/lib/libident.a' '${libident}/lib/libident.a'

    substituteInPlace Makefile \
      --replace 'CFLAGS = -O2 -Wall -Wsurprising' 'CFLAGS = -O2 -Wall -Wsurprising -fcommon'
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/sbin

    install -Dm755 efingerd $out/sbin/efingerd

    runHook postInstall
  '';
  doInstallCheck = true;
  # The binary is silly and still prints 1.6.4
  preVersionCheck = ''
    export version=1.6.4
  '';
  meta = with lib; {
    homepage = "https://kassiopeia.juls.savba.sk/~garabik/software/efingerd.html";
    description = "finger daemon that gives you complete control over what to send";
    mainProgram = "efingerd";
    maintainers = with maintainers; [
      ezrizhu
    ];
    license = with licenses; [ gpl2 ];
    platforms = platforms.linux;
  };
}
