{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "disk-filltest";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "bingmann";
    repo = "disk-filltest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cppofTzzJHrvG5SsafKgvCIiHc6E5740NyQdWWZxrGI=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "prefix=${placeholder "out"}"
    "man1dir=${placeholder "man"}/share/man/man1"
  ];

  postInstall = ''
    install -D -m0644 -t $doc/share/doc/disk-filltest README
  '';

  meta = {
    homepage = "https://panthema.net/2013/disk-filltest";
    description = "Simple program to detect bad disks by filling them with random data";
    longDescription = ''
      disk-filltest is a tool to check storage disks for coming failures by
      write files with pseudo-random data to the current directory until the
      disk is full, read the files again and verify the sequence written. It
      also can measure read/write speed while filling the disk.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "disk-filltest";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
