{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libX11,
  libXext,
  libXrandr,
  pkg-config,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "master_me";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "trummerschlunk";
    repo = "master_me";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-eesMXxRcCgzhSQ+WUqM00EuKYhFxysjH+RWKHKGYzUM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libGL
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXext
    libXrandr
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./dpf/utils/
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/trummerschlunk/master_me";
    description = "Automatic mastering plugin for live streaming, podcasts and internet radio";
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # error: no type or protocol named 'NSPasteboardType'
    license = lib.licenses.gpl3Plus;
    mainProgram = "master_me";
  };
})
