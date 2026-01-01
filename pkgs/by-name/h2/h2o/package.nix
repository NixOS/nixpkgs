{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  ninja,
  perl,
  brotli,
  openssl,
  libcap,
  libuv,
  wslay,
  zlib,
  withMruby ? true,
  bison,
  ruby,
  withUring ? stdenv.hostPlatform.isLinux,
  liburing,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "h2o";
<<<<<<< HEAD
  version = "2.3.0-rolling-2025-12-05";
=======
  version = "2.3.0-rolling-2025-11-08";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "h2o";
    repo = "h2o";
<<<<<<< HEAD
    rev = "df3d192f701e48864459fff80bc81135c339b7b0";
    hash = "sha256-XArZFBkV0nnsh+QXmoZUttvB9vlz8+CrFWaQt8dR7n4=";
=======
    rev = "607b732b668a06826709c0f72bd4fd680f2372bc";
    hash = "sha256-JdtBedmz84LnlePKif3vnq5YbTAIumvzPcjlJ/Br5hQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "man"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
    ninja
  ]
  ++ lib.optionals withMruby [
    bison
    ruby
  ]
  ++ lib.optional withUring liburing;

  buildInputs = [
    brotli
    openssl
    libcap
    libuv
    perl
    zlib
    wslay
  ];

  cmakeFlags = [
    "-DWITH_MRUBY=${if withMruby then "ON" else "OFF"}"
  ];

  postInstall = ''
    EXES="$(find "$out/share/h2o" -type f -executable)"
    for exe in $EXES; do
      wrapProgram "$exe" \
        --set "H2O_PERL" "${lib.getExe perl}" \
        --prefix "PATH" : "${lib.getBin openssl}/bin"
    done
  '';

  passthru = {
    tests = { inherit (nixosTests) h2o; };
  };

<<<<<<< HEAD
  meta = {
    description = "Optimized HTTP/1.x, HTTP/2, HTTP/3 server";
    homepage = "https://h2o.examp1e.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Optimized HTTP/1.x, HTTP/2, HTTP/3 server";
    homepage = "https://h2o.examp1e.net";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      toastal
      thoughtpolice
    ];
    mainProgram = "h2o";
<<<<<<< HEAD
    platforms = lib.platforms.linux;
=======
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
