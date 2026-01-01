{
  stdenvNoCC,
  fetchFromGitLab,
  lib,
  python3,
  rdfind,
  which,
  writeShellScriptBin,
}:
let
  # check-whence.py attempts to call `git ls-files`, but we don't have a .git,
  # because we've just downloaded a snapshot. We do, however, know that we're
  # in a perfectly pristine tree, so we can fake just enough of git to run it.
  gitStub = writeShellScriptBin "git" ''
    if [ "$1" == "ls-files" ]; then
      find -type f -printf "%P\n"
    else
      echo "Git stub called with unexpected arguments $@" >&2
      exit 1
    fi
  '';
in
<<<<<<< HEAD
stdenvNoCC.mkDerivation {
  pname = "linux-firmware";
  version = "20251125-unstable-2025-12-18";
=======
stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20251125";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "kernel-firmware";
    repo = "linux-firmware";
<<<<<<< HEAD
    rev = "881c549a82203abd9a88870ba27f3e8ce754b2c4";
    hash = "sha256-ziKzNbP8pqwFilzQb227FtVMqaUGDcbZ57tc9mAMSxs=";
=======
    tag = version;
    hash = "sha256-eNzCgVx6iPWbPccMM1TLBIsFKwiha9/gajmFtobj4SE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postUnpack = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    gitStub
    python3
    rdfind
    which
  ];

  installTargets = [
    "install"
    "dedup"
  ];
  makeFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  meta = {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = lib.licenses.unfreeRedistributableFirmware;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
}
