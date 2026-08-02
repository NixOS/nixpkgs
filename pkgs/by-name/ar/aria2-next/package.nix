{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  perl,
  makeWrapper,
  installShellFiles,
  cacert,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aria2-next";
  version = "3.0.8";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AnInsomniacy";
    repo = "aria2-next";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BPqOWxiS5OkygEHi4N8Cl9kyvKGa2iimYIJ4IK1pBVE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
    makeWrapper
    installShellFiles
    cacert
  ];

  postPatch = ''
    # Force lib/ install dir for vendored deps
    substituteInPlace cmake/superbuild/Dependencies.cmake \
      --replace-fail \
        '-DCMAKE_POSITION_INDEPENDENT_CODE=ON)' \
        '-DCMAKE_POSITION_INDEPENDENT_CODE=ON
      -DCMAKE_INSTALL_LIBDIR=lib)'
  '';

  installPhase = ''
    runHook preInstall

    installBin ./aria2-next

    runHook postInstall
  '';

  postInstall = ''
    # Set CA cert paths for HTTPS
    wrapProgram $out/bin/aria2-next \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --set SSL_CERT_DIR "${cacert}/etc/ssl/certs"
  '';

  passthru = {
    tests.aria2-next = nixosTests.aria2-next;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/AnInsomniacy/aria2-next";
    changelog = "https://github.com/AnInsomniacy/aria2-next/releases/tag/v${finalAttrs.version}";
    description = "Aria2 fork with extensive bug fixes and modernized architecture";
    longDescription = ''
      Aria2 Next is an actively maintained download engine and the embedded engine used by Rayburst.
      HTTP, HTTPS, SFTP, Metalink, ED2K, RPC, and libaria2 remain supported.
      HTTP, HTTPS, SFTP, and Metalink payload transfers use libcurl 8.21 with nghttp2.
      BitTorrent uses libtorrent-rasterbar 2.1.
      FTP and the former custom stream protocol stacks have been removed.
    '';
    mainProgram = "aria2-next";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ProxyVT ];
  };
})
