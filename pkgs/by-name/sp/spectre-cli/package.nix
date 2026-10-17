{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  libsodium,
  json_c,
  ncurses,
  libxml2,
  jq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectre-cli";
  version = "unstable-2022-02-05";

  src = fetchFromGitLab {
    owner = "spectre.app";
    repo = "cli";
    rev = "a5e7aab28f44b90e5bd1204126339a81f64942d2";
    hash = "sha256-sTTKrr8rUJMyE/5ZpwsxiRrPdkYgKgZBf3+dB3Og5MI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libxml2
    jq
  ];

  buildInputs = [
    libsodium
    json_c
    ncurses
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_SPECTRE_TESTS=ON"
  ];

  preConfigure = ''
    echo "${finalAttrs.version}" > VERSION

     # The default buildPhase wants to create a ´build´ dir so we rename the build script to stop conflicts.
     mv build build.sh
  '';

  # Some tests are expected to fail on ARM64
  # See: https://gitlab.com/spectre.app/cli/-/issues/27#note_962950844
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  checkPhase = ''
    mv ../spectre-cli-tests ../spectre_tests.xml ./
    patchShebangs spectre-cli-tests
    export HOME=$(mktemp -d)

    ./spectre-tests
    ./spectre-cli-tests
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv spectre $out/bin
  '';

  meta = {
    description = "Stateless cryptographic identity algorithm";
    homepage = "https://spectre.app";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ emmabastas ];
    mainProgram = "spectre";
    platforms = lib.platforms.all;
  };
})
