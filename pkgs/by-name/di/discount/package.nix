{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.0.2.0";
  pname = "discount";

  src = fetchFromGitHub {
    owner = "Orc";
    repo = "discount";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VApMh5Q+4ZKVIhXbXwqcm6TIP3kcZHs5vZojpSP1F+8=";
  };

  patches = [ ./fix-configure-path.patch ];
  configureScript = "./configure.sh";
  configureFlags = [
    "--shared"
    "--debian-glitch" # use deterministic mangling
    "--pkg-config"
    "--h1-title"
  ];

  enableParallelBuilding = true;
  installTargets = [ "install.everything" ];

  doCheck = true;

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id "$out/lib/libmarkdown.dylib" "$out/lib/libmarkdown.dylib"
    for exe in $out/bin/*; do
      install_name_tool -change libmarkdown.dylib "$out/lib/libmarkdown.dylib" "$exe"
    done
  '';

  meta = {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shell ];
    mainProgram = "markdown";
    platforms = lib.platforms.unix;
  };
})
