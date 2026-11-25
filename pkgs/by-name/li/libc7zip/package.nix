{
  lib,
  stdenv,
  fetchFromGitHub,
  _7zz,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libc7zip";
  version = "1.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "libc7zip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dh761z1PK+G76r/cn0MV+kW2uaCPpK79jtYJ7fN1IdQ=";
  };

  postPatch = ''
    substituteInPlace vendor/lib7zip/CMakeLists.txt \
      --replace-fail 'URL ''${UPSTREAM_SRC_URL}' 'URL ${_7zz.src}'
    substituteInPlace vendor/lib7zip/Lib7Zip/OSFunctions_UnixLike.cpp \
      --replace-fail 'DirName(SelfPath()) + "/" +' '"${lib.getLib _7zz}/lib/" +'
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck) ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ctest --test-dir test --output-on-failure --no-tests=error

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/lib libc7zip${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm644 -t $out/include ../include/libc7zip.h

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C interface to lib7zip, used by butler to extract archives";
    homepage = "https://github.com/itchio/libc7zip";
    changelog = "https://github.com/itchio/libc7zip/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        mit
        lgpl21Plus
        mpl20
      ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
