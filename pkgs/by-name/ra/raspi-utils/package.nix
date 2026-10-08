{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  makeBinaryWrapper,
  pkg-config,
  bashNonInteractive,
  coreutils,
  dtc,
  gawk,
  gitMinimal,
  gnugrep,
  gnutls,
  gnutar,
  kmod,
  ncurses,
  perl,
  python3,
  targetPackages,
  util-linux,
  which,
  zstd,
  cc ? targetPackages.stdenv.cc,
}:

let
  runtimePath = lib.makeBinPath [
    coreutils
    dtc
    gawk
    gitMinimal
    gnugrep
    gnutar
    kmod
    cc
    util-linux
    which
    zstd
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "raspi-utils";
  version = "0-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "utils";
    rev = "292dbe7e35296e556d839a0b9ae2ca957ac8c961";
    hash = "sha256-8F4dJDsYqiJWBYqfVHKPpYgATQQM5QohcxhtJ7EQH3o=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    bashNonInteractive
    dtc
    gnutls
    ncurses
    perl
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(raspinfo)" ""

    substituteInPlace dtapply/dtapply \
      --replace-fail \
        "parser = argparse.ArgumentParser(" \
        'parser = argparse.ArgumentParser(prog="dtapply",'
    substituteInPlace eeptools/eepflash.sh \
      --replace-fail 'me=$(basename "$0")' 'me=eepflash.sh'
    substituteInPlace otamaker/otamaker \
      --replace-fail \
        "parser = argparse.ArgumentParser()" \
        "parser = argparse.ArgumentParser(prog='otamaker')"
    substituteInPlace otpset/otpset \
      --replace-fail \
        "parser = argparse.ArgumentParser(description=" \
        "parser = argparse.ArgumentParser(prog='otpset', description="
    substituteInPlace overlaycheck/overlaycheck \
      --replace-fail \
        'my $exclusions_file = $0 . "_exclusions.txt";' \
        'my $exclusions_file = "${placeholder "out"}/bin/overlaycheck_exclusions.txt";'
  '';

  postFixup = ''
    for program in \
      dtapply \
      dtoverlay \
      eepflash.sh \
      kdtc \
      otamaker \
      otpset \
      overlaycheck \
      ovmerge
    do
      wrapProgram "$out/bin/$program" \
        --prefix PATH : "$out/bin:${runtimePath}"
    done
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Scripts and applications for interfacing with Raspberry Pi hardware";
    homepage = "https://github.com/raspberrypi/utils";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jamiemagee ];
    platforms = [
      "armv6l-linux"
      "armv7l-linux"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
