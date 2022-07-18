{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "box64";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6k8Enbafnj19ATtgmw8W7LxtRpM3Ousj1bpZbbtq8TM=";
  };

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

  meta = with lib; {
    homepage = "https://box86.org/";
    description = "Lets you run x86_64 Linux programs on non-x86_64 Linux systems";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
