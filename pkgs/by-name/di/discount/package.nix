{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  version = "3.0.1";
  pname = "discount";

  src = fetchFromGitHub {
    owner = "Orc";
    repo = "discount";
    rev = "v${version}";
    hash = "sha256-Bb6vcEICzxaQmBIm9xQy5dKV485iwcxgkA3PAHaR2cw=";
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

  meta = with lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shell ];
    mainProgram = "markdown";
    platforms = platforms.unix;
  };
}
