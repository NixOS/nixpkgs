{ stdenv
, lib
, fetchFromGitHub
, cmake
, libuv
, libmicrohttpd
, openssl
, hwloc
, donateLevel ? 0
, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks) Carbon CoreServices OpenCL;
in
stdenv.mkDerivation rec {
  pname = "xmrig";
<<<<<<< HEAD
  version = "6.20.0";
=======
  version = "6.19.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-csJfmjKm/uAlINhijeqUsDVTemchlzWqJg/YHtmNlAk=";
=======
    hash = "sha256-m8ot/IbpxdzHOyJymzZ7MWt4p78GTUuTjYZ9P1oGpWI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./donate-level.patch
  ];

  postPatch = ''
    substituteAllInPlace src/donate.h
    substituteInPlace cmake/OpenSSL.cmake \
      --replace "set(OPENSSL_USE_STATIC_LIBS TRUE)" "set(OPENSSL_USE_STATIC_LIBS FALSE)"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libuv
    libmicrohttpd
    openssl
    hwloc
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    CoreServices
    OpenCL
  ];

  inherit donateLevel;

  installPhase = ''
    runHook preInstall

    install -vD xmrig $out/bin/xmrig

    runHook postInstall
  '';

<<<<<<< HEAD
  # https://github.com/NixOS/nixpkgs/issues/245534
  hardeningDisable = [ "fortify" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kim0 ];
  };
}
