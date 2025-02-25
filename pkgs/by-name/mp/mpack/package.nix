{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  testers,
  mpack,
}:

stdenv.mkDerivation rec {
  pname = "mpack";
  version = "1.6";

  src = fetchurl {
    url = "http://ftp.andrew.cmu.edu/pub/mpack/mpack-${version}.tar.gz";
    hash = "sha256-J0EIuzo5mCpO/BT7OmUpjmbI5xNnw9q/STOBYtIHqUw=";
  };

  patches =
    let
      # https://salsa.debian.org/debian/mpack/-/tree/7d6514b314a7341614ec8275b03acfcb6a854a6f/debian/patches
      fetchDebPatch =
        { name, hash }:
        fetchpatch {
          inherit name hash;
          url = "https://salsa.debian.org/debian/mpack/-/raw/7d6514b314a7341614ec8275b03acfcb6a854a6f/debian/patches/${name}";
        };
    in
    [
      ./sendmail-via-execvp.diff
    ]
    ++ (map fetchDebPatch [
      {
        name = "01_legacy.patch";
        hash = "sha256-v2pZUXecgxJqoHadBhpAAoferQNSeYE+m7qzEiggeO4=";
      }
      {
        name = "02_fix-permissions.patch";
        hash = "sha256-sltnIqgv7+pwwSFQRCDeCwnjoo2OrvmGFm+SM9U/HB4=";
      }
      {
        name = "03_specify-filename-replacement-character.patch";
        hash = "sha256-vmLIGFSqKK/qSsltzhdLQGoekew3r25EwAu56umeXlU=";
      }
      {
        name = "04_fix-return-error-code.patch";
        hash = "sha256-l23D6xhkgtkEsErzUy/q6U3aPf5N7YUw2PEToU1YXKI=";
      }
      {
        name = "06_fix-makefile.patch";
        hash = "sha256-69plDqy2sLzO1O4mqjJIlTRCw5ZeVySiqwo93ZkX3Ho=";
      }
      {
        name = "07_fix-decode-base64-attachment.patch";
        hash = "sha256-hzSCrEg0j6dJNLbfwRNn+rWGRnyUBLjJUlORJS9aDD4=";
      }
      {
        name = "08_fix-mime-version.patch";
        hash = "sha256-l2rBqbyKmnz5tEPeuX6HCqw7rSV8pDb7ijpCHsdh57g=";
      }
      {
        name = "09_remove-debugging-message.patch";
        hash = "sha256-dtq6BHgH4ciho0+TNW/rU3KWoeKs/1jwJafnHTr9ebI=";
      }
    ]);

  postPatch = ''
    substituteInPlace *.{c,man,pl,unix} --replace-quiet /usr/tmp /tmp

    # silence a buffer overflow warning
    substituteInPlace uudecode.c \
      --replace-fail "char buf[1024], buf2[1024];" "char buf[1024], buf2[1066];"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/mpack INSTALL README.*
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    version = testers.testVersion {
      command = ''
        mpack 2>&1 || echo "mpack exited with error code $?"
      '';
      package = mpack;
      version = "mpack version ${version}";
    };
  };

  meta = with lib; {
    description = "Utilities for encoding and decoding binary files in MIME";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
