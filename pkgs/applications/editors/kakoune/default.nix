{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kakoune-unwrapped";
  version = "2025.06.03";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AJvh6NVFpbPsyzfeii/5muE+i4TwfxhwhDVgMLYOJCM=";
  };

  # On Darwin, bundle termux/wcwidth for proper Unicode 15 emoji support.
  # macOS libc has outdated Unicode tables causing wcwidth() to return -1
  # for modern emoji, resulting in display corruption.
  # See: https://github.com/mawww/kakoune/issues/3059
  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin-wcwidth.patch ];

  wcwidth = fetchurl {
    url = "https://raw.githubusercontent.com/termux/wcwidth/911263c514237997c9c590517672c6ea729388dc/wcwidth.c";
    hash = "sha256-AMo/+xE6Kju6tK8OK5RaLT44/GFH/YfnGTcK6mqybCU=";
  };

  makeFlags = [
    "debug=no"
    "PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    echo "v${finalAttrs.version}" >.version
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Add termux wcwidth for Unicode 15 emoji support
    cp ${finalAttrs.wcwidth} src/wcwidth.c
  '';

  enableParallelBuilding = true;
  preBuild = ''
    appendToVar makeFlags "CXX=$CXX"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Compile wcwidth.c with function renamed to mk_wcwidth
    $CC -c -o src/wcwidth.o src/wcwidth.c -Dwcwidth=mk_wcwidth
    appendToVar makeFlags "LDFLAGS=src/wcwidth.o"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -e "kill 0"
  '';

  postInstall = ''
    # make share/kak/autoload a directory, so we can use symlinkJoin with plugins
    cd "$out/share/kak"
    autoload_target=$(readlink autoload)
    rm autoload
    mkdir autoload
    ln -s --relative "$autoload_target" autoload
  '';

  meta = {
    homepage = "http://kakoune.org/";
    description = "Vim inspired text editor";
    license = lib.licenses.publicDomain;
    mainProgram = "kak";
    maintainers = with lib.maintainers; [ philiptaron ];
    platforms = lib.platforms.unix;
  };
})
