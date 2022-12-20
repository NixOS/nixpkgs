{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gitUpdater
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "box64";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eMp2eSWMRJQvLRQKUirBua6Kt7ZtyebfUnKIlibkNFU=";
  };

  patches = [
    # Fix mmx & cppThreads tests on x86_64
    # Remove when version > 0.2.0
    (fetchpatch {
      url = "https://github.com/ptitSeb/box64/commit/3819aecf078fcf47b2bc73713531361406a51895.patch";
      hash = "sha256-11hy5Ol5FSE/kNJmXAIwNLbapldhlZGKtOLIoL6pYrg=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    "-DNOGIT=1"
  ] ++ (
    if stdenv.hostPlatform.system == "aarch64-linux" then
      [
        "-DARM_DYNAREC=ON"
      ]
    else [
      "-DLD80BITS=1"
      "-DNOALIGN=1"
    ]
  );

  installPhase = ''
    runHook preInstall
    install -Dm 0755 box64 "$out/bin/box64"
    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ctest
    runHook postCheck
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/box64 -v
    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://box86.org/";
    description = "Lets you run x86_64 Linux programs on non-x86_64 Linux systems";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
