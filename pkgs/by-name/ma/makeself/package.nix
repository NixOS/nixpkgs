{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  zstd,
  pbzip2,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "makeself";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "megastep";
    repo = "makeself";
    tag = "release-${version}";
    fetchSubmodules = true;
    hash = "sha256-F5lx8B2C8CsEUXQPQTK1q8PAMf5yzIEAqq3zbYnseTs=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postPatch = "patchShebangs test";

  # Issue #110149: our default /bin/sh apparently has 32-bit math only
  # (attribute busybox-sandbox-shell), and that causes problems
  # when running these tests inside build, based on free disk space.
  doCheck = false;
  checkTarget = "test";
  nativeCheckInputs = [
    which
    zstd
    pbzip2
  ];

  sharePath = "$out/share/${pname}";

  installPhase = ''
    runHook preInstall
    installManPage makeself.1
    install -Dm555 makeself.sh $out/bin/makeself
    install -Dm444 -t ${sharePath}/ README.md makeself-header.sh
    runHook postInstall
  '';

  fixupPhase = ''
    sed -e "s|^HEADER=.*|HEADER=${sharePath}/makeself-header.sh|" -i $out/bin/makeself
  '';

  meta = with lib; {
    homepage = "https://makeself.io";
    description = "Utility to create self-extracting packages";
    license = licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
    mainProgram = "makeself";
  };
}
