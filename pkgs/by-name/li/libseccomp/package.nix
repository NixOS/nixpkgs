{
  lib,
  stdenv,
  fetchurl,
  getopt,
  util-linuxMinimal,
  which,
  gperf,
  nix-update-script,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "libseccomp";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    hash = "sha256-g7YIUjLRWIw3ncm5yuR7s3QHzyYubnSZPGG6ctKnhNw=";
  };

  patches = [
    ./oob-read.patch
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
    "pythonsrc"
  ];

  nativeBuildInputs = [ gperf ];
  buildInputs = [ getopt ];

  postPatch = ''
    patchShebangs .
  '';

  nativeCheckInputs = [
    util-linuxMinimal
    which
  ];
  doCheck = !(stdenv.targetPlatform.useLLVM or false);

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rfv src";

  # Copy the python module code into a tarball that we can export and use as the
  # src input for buildPythonPackage calls
  postInstall = ''
    cp -R ./src/python/ tmp-pythonsrc/
    tar -zcf $pythonsrc --mtime="@$SOURCE_DATE_EPOCH" --sort=name --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (python3Packages) seccomp;
    };
  };

  meta = with lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    mainProgram = "scmp_sys_resolver";
    homepage = "https://github.com/seccomp/libseccomp";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    badPlatforms = [
      "alpha-linux"
      "loongarch64-linux"
      "m68k-linux"
      "microblaze-linux"
      "microblazeel-linux"
      "riscv32-linux"
      "sparc-linux"
      "sparc64-linux"
    ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
