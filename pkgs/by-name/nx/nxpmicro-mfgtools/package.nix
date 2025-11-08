{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  bzip2,
  installShellFiles,
  libusb1,
  libzip,
  openssl,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "nxpmicro-mfgtools";
  version = "1.5.139";

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "mfgtools";
    rev = "uuu_${version}";
    sha256 = "sha256-t5usUGbcdLQlqPpZkNDeGncka9VfkpO7U933Kw/Sm7U=";
  };

  patches = [
    # build: support cmake 4.0
    (fetchpatch {
      url = "https://github.com/nxp-imx/mfgtools/commit/311ee9b3cca0275fbb5eb5228c56edbb518afd67.patch?full_index=1";
      hash = "sha256-o4cPfXsPxk88zy5lARX8rcmQncsAkZegOxlAIyoFUpQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    bzip2
    libusb1
    libzip
    openssl
    zstd
  ];

  doInstallCheck = true;

  preConfigure = "echo ${version} > .tarball-version";

  postInstall = ''
    # rules printed by the following invocation are static,
    # they come from hardcoded configs in libuuu/config.cpp:48
    $out/bin/uuu -udev > udev-rules 2>stderr.txt
    rules_file="$(cat stderr.txt|grep '1: put above udev run into'|sed 's|^.*/||')"
    install -D udev-rules "$out/lib/udev/rules.d/$rules_file"
    installShellCompletion --cmd uuu \
      --bash ../snap/local/bash-completion/universal-update-utility
  '';

  meta = with lib; {
    description = "Freescale/NXP I.MX chip image deploy tools";
    longDescription = ''
      UUU (Universal Update Utility) is a command line tool, evolved out of
      MFGTools (aka MFGTools v3).

      One of the main purposes is to upload images to I.MX SoC's using at least
      their boot ROM.

      With time, the need for an update utility portable to Linux and Windows
      increased. UUU has the same usage on both Windows and Linux. It means the same
      script works on both OS.
    '';
    homepage = "https://github.com/NXPmicro/mfgtools";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      bmilanov
      jraygauthier
    ];
    mainProgram = "uuu";
    platforms = platforms.all;
  };
}
