{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  sqlite,
  xcbuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mps";
  version = "1.118.0";

  src = fetchFromGitHub {
    owner = "Ravenbrook";
    repo = "mps";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-3ql3jWLccgnQHKf23B1en+nJ9rxqmHcWd7aBr93YER0=";
  };

  sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin "${finalAttrs.src.name}/code";

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Disable -Werror to avoid biuld failure on fresh toolchains like
    # gcc-13.
    substituteInPlace code/gc.gmk \
      --replace-fail "-Werror " " "
    substituteInPlace code/gp.gmk \
      --replace-fail "-Werror " " "
    substituteInPlace code/ll.gmk \
      --replace-fail "-Werror " " "
  '';

  nativeBuildInputs =
    (lib.optionals stdenv.hostPlatform.isLinux [ autoreconfHook ])
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [ xcbuildHook ]);

  buildInputs = [ sqlite ];

  xcbuildFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-configuration"
    "Release"
    "-project"
    "mps.xcodeproj"
    # "-scheme"
    # "mps"
    "OTHER_CFLAGS='-Wno-error=unused-but-set-variable'"
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    install -Dm644 Products/Release/libmps.a $out/lib/libmps.a
    mkdir $out/include
    cp mps*.h $out/include/

    runHook postInstall
  '';

  meta = {
    description = "Flexible memory management and garbage collection library";
    homepage = "https://www.ravenbrook.com/project/mps";
    license = lib.licenses.sleepycat;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
})
