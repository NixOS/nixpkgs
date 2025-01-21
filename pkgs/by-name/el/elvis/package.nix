{
  lib,
  fetchurl,
  fetchpatch,
  installShellFiles,
  ncurses,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elvis";
  version = "2.2_0";

  src = fetchurl {
    urls = [
      "http://www.the-little-red-haired-girl.org/pub/elvis/elvis-${finalAttrs.version}.tar.gz"
      "http://www.the-little-red-haired-girl.org/pub/elvis/old/elvis-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-moRmsik3mEQQVrwnlzavOmFrqrovEZQDlsxg/3GSTqA=";
  };

  patches = [
    (fetchpatch {
      name = "0000-resolve-stdio-getline-naming-conflict.patch";
      url = "https://github.com/mbert/elvis/commit/076cf4ad5cc993be0c6195ec0d5d57e5ad8ac1eb.patch";
      hash = "sha256-DCo2caiyE8zV5ss3O1AXy7oNlJ5AzFxdTeBx2Wtg83s=";
    })
  ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  configureFlags = [ "--ioctl=termios" ];

  strictDeps = false;

  postPatch = ''
    substituteInPlace configure \
      --replace-fail '-lcurses' '-lncurses'
  '';

  installPhase = ''
    runHook preInstall

    installBin elvis ref elvtags elvfmt

    pushd doc
    for page in *.man; do
      installManPage $page
      rm $page
    done
    popd

    mkdir -p $out/share/doc/elvis-${finalAttrs.version}/ $out/share/elvis/
    cp -R data/* $out/share/elvis/
    cp doc/* $out/share/doc/elvis-${finalAttrs.version}/

    runHook postInstall
  '';

  meta = {
    homepage = "http://elvis.the-little-red-haired-girl.org/";
    description = "Vi clone for Unix and other operating systems";
    license = lib.licenses.free;
    mainProgram = "elvis";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
