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
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "megastep";
    repo = "makeself";
    tag = "release-${version}";
    fetchSubmodules = true;
    hash = "sha256-X35vdzsfAQWAHMvlQSxCeu7IgUNVvnOQaakS27SXlFA=";
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

  meta = {
    homepage = "https://makeself.io";
    description = "Utility to create self-extracting packages";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.all;
    mainProgram = "makeself";
  };
}
