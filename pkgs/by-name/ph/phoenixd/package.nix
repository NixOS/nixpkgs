{
  stdenv,
  lib,
  fetchurl,
  unzip,
  autoPatchelfHook,
  libgcc,
  libxcrypt-legacy,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "phoenixd";
  version = "0.5.0";

  suffix =
    {
      aarch64-darwin = "macos-arm64";
      x86_64-darwin = "macos-x64";
      x86_64-linux = "linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/ACINQ/phoenixd/releases/download/v${version}/phoenix-${version}-${suffix}.zip";
    hash =
      {
        aarch64-darwin = "sha256-hfg/gca27t8psG1+7u5DvHCuQDQJou6Fp3+ySaz+MXc=";
        x86_64-darwin = "sha256-qpwkt2rbilpQVmAkl6Q4XyecSzayzYb1k5H5ur7SItk=";
        x86_64-linux = "sha256-lshsJQ9km8C+KDtp1nQiK8h7LJN3A8GlGN6Yhb3VPtk=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    libgcc # provides libgcc_s.so.1
    libxcrypt-legacy # provides libcrypt.so.1
    zlib # provides libz.so.1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp phoenix{-cli,d} $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Server equivalent of the popular Phoenix wallet for mobile";
    homepage = "https://phoenix.acinq.co/server";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
