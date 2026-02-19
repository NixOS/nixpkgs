{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,

  enablePython ? false,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libplist";
  version = "2.7.0";

  outputs = [
    "bin"
    "dev"
    "out"
  ]
  ++ lib.optional enablePython "py";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libplist";
    rev = finalAttrs.version;
    hash = "sha256-Rc1KwJR+Pb2lN8019q5ywERrR7WA2LuLRiEvNsZSxXc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals enablePython [
    python3
    python3.pkgs.cython
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  configureFlags = [
    "--enable-debug"
  ]
  ++ lib.optionals (!enablePython) [
    "--without-cython"
  ];

  doCheck = true;

  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = {
    description = "Library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "plistutil";
  };
})
